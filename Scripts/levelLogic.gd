extends Node2D

@export var timers: Array[float]
@onready var nodes_to_reset: Node2D = $NodesToReset
@onready var camera_2d: Camera2D = $Camera2D
@onready var player_start: Node2D = $PlayerStart
@onready var maxClonesForLevel = player_start.maxClonesForLevel

var levelHasStarted = 0 # 1 after the player presses space to start

var current_scene_path # path of the current level
var to_reset_scene_path # path to the scene that has everything that needs resetting
var to_reset_scene # scene preloaded to be instantiated later on rollback

var player #reference to the current player
@export var timeToWaitBetweenCloneSpawns = 1.0

signal levelWon
signal levelLost
 
var canRollback = false
var currentCloneIndex = 0 # 0 if first player run, 1 if 2nd run meaning already a clone, etc
var clones : Array[Player]
var player_scene #stores a preload of the player scene
var currentTimer #store the "Timer" Node that is currently running
var timerUIs = [] #array referencing all the timers shown in game. 0 is the first run, n-1 the last one
var timer_ui_for_each_life_scene #stores a preload of the timer ui scene

var dead_player_scene = preload("res://Objects/dead_player.tscn") 
var dead_bodies = []

var firstTimerUIPosition #where the first timer is
var timerUIPositionOffset = Vector2(50.0, 0.0) #where the second timer is in relation to the first

# vars that need reconnecting once I reset the level on rollback
var player_end

#to be called at the start and after every to_reset_scene reset
func instantiate_vars_and_connect_signals_on_to_reset_scene_ready():
	player_end = nodes_to_reset.get_node("PlayerEnd")
	player_end.endDoorReached.connect(_level_won)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	firstTimerUIPosition = Vector2(-946.0, -524.0) / camera_2d.zoom
	instantiate_vars_and_connect_signals_on_to_reset_scene_ready()
	current_scene_path = scene_file_path
	to_reset_scene_path = str(current_scene_path.left(-5),"ToReset.tscn")
	print(to_reset_scene_path)
	to_reset_scene = load(to_reset_scene_path)
	timer_ui_for_each_life_scene = preload("res://Objects/timer_ui_for_each_life.tscn")
	player_scene = preload("res://Objects/Player.tscn")
	
	#show timers
	if not timers.is_empty():
		var currentTimerUIPosition = firstTimerUIPosition
		for timer in timers:
			var timerUI = timer_ui_for_each_life_scene.instantiate()
			add_child(timerUI)
			timerUI.update_position(currentTimerUIPosition)
			timerUI.update_text(str(timer))
			timerUIs.append(timerUI)
			currentTimerUIPosition += timerUIPositionOffset
	#start_level() # I can make this called later when user presses space

func start_level():
	spawn_player()
	if not timers.is_empty():
		start_timer_and_connect_signal(timers[0])
	canRollback = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#start level when player presses space # move this logic to higher node later on (with label for it)
	if not levelHasStarted:
		if Input.is_action_just_pressed("start level"): 
			levelHasStarted = 1
			start_level()
	#update timerUIs
	if currentTimer and not currentTimer.is_stopped():
		var currentTimerUI = timerUIs[currentCloneIndex]
		currentTimerUI.update_text(str(currentTimer.get_time_left()))
	
	if Input.is_action_just_pressed("Rollback") and canRollback:
		rollback(0)

# Spawns player at start
func spawn_player():
	player = player_scene.instantiate()
	player.player_or_clone_dead.connect(on_player_or_clone_death)
	player.cloneIndex = currentCloneIndex
	player.position = player_start.position
	
	add_child(player)
	player_start.decrement_clones_left()


#spawns clone and passes it current recording from player. Returns clone to be saved in var
#spawned clone instantly plays back the recordings
func spawn_clone():
	var clone = player_scene.instantiate()
	clone.player_or_clone_dead.connect(on_player_or_clone_death)
	clone.cloneIndex = currentCloneIndex
	clone.position = player_start.position
	clone.recordedInputs = player.recordedInputs.duplicate(true)
	player.recordedInputs.clear()
	clone.isPlayingBack = 1
	
	add_child(clone)
	
	
	return clone

#sets clones opacity based on how recent it is.
func set_clone_opacity(clone):
	var opacity = clamp(1 - 0.2 * (currentCloneIndex - clone.cloneIndex + 1), 0.3, 1.0)
	clone.PlayerSprite.modulate = Color(1,1,1,opacity)

#function to rollback player and spawn clones. "wasAutomatic" is 1 when called by timer, 0 when called by player signal
func rollback(wasAutomatic):
	if currentCloneIndex >= maxClonesForLevel:
		print("can't rollback coz reached limit")
		return
	canRollback = false
	
	player_start.update_clones_left(maxClonesForLevel)
	
	currentCloneIndex += 1
	
	#if the rollback was manual I need to stop the current timer
	if currentTimer: currentTimer.timeout.disconnect(_on_timer_timeout)
	
	# reset and hide player and clones we already had
	player.position = player_start.position
	disable_player_or_clone(player)
	for clone in clones:
		clone.position = player_start.position
		clone.playbackIndex = 0
		disable_player_or_clone(clone)
	remove_dead_bodies()
	
	# reset interactables and animatables in level
	var new_to_reset_scene = to_reset_scene.instantiate()
	nodes_to_reset.queue_free()
	add_child(new_to_reset_scene)
	nodes_to_reset = new_to_reset_scene
	instantiate_vars_and_connect_signals_on_to_reset_scene_ready() #reconnect stuff to new scene
	
	#play the clones we already had
	for clone in clones:
		await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
		enable_player_or_clone(clone)
		set_clone_opacity(clone)
		player_start.decrement_clones_left()
	
	#spawn the newest clone
	await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
	clones.append(spawn_clone())
	set_clone_opacity(clones[-1])
	player_start.decrement_clones_left()
	
	#enable player
	await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
	enable_player_or_clone(player)
	player_start.decrement_clones_left()
	
	#start the next timer
	if not timers.is_empty(): 
		if currentCloneIndex < timers.size():
			start_timer_and_connect_signal(timers[currentCloneIndex])
	
	canRollback = true

# hides/shows player/clone and enables/disables physics
func enable_player_or_clone(playerOrClone):
	playerOrClone.visible = true
	playerOrClone.collision_shape.disabled = false
	playerOrClone.set_physics_process(true)
	playerOrClone.isDead = false

func disable_player_or_clone(playerOrClone):
	playerOrClone.visible = false
	playerOrClone.collision_shape.disabled = true
	playerOrClone.set_physics_process(false)
	playerOrClone.drop_all.emit(playerOrClone)

func start_timer_and_connect_signal(seconds):
	currentTimer = Timer.new()
	currentTimer.one_shot = true
	currentTimer.wait_time = seconds
	add_child(currentTimer)
	currentTimer.timeout.connect(_on_timer_timeout)
	currentTimer.start()

func on_player_or_clone_death(playerWhoDied):
	print(playerWhoDied)
	disable_player_or_clone(playerWhoDied)
	var dead_player = dead_player_scene.instantiate()
	add_child(dead_player)
	dead_player.position = playerWhoDied.position
	dead_player.get_node("Sprite2D").modulate = playerWhoDied.PlayerSprite.modulate
	dead_bodies.append(dead_player)

func remove_dead_bodies():
	for body in dead_bodies:
		body.queue_free()
	dead_bodies.clear()

# do a rollback each time a "life" timer times out
func _on_timer_timeout():
	if currentCloneIndex >= maxClonesForLevel:
		level_lost()
	else:
		rollback(1)

#body is the body that entered the door at the end
func _level_won(body):
	print(str("good job, you won by reaching the door with ", body.cloneIndex))
	body.queue_free()
	levelWon.emit()
	get_tree().paused = true

func level_lost():
	print(str("RIP, you lost. Restarting level in 3"))
	levelLost.emit()
	get_tree().paused = true
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
	
