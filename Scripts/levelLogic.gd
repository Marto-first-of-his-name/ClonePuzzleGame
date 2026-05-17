extends Node2D

@export var timers: Array[float]
@onready var nodes_to_reset: Node2D = $NodesToReset

@onready var player_start: Node2D = $PlayerStart
@onready var maxClonesForLevel = player_start.maxClonesForLevel

var current_scene_path # path of the current level
var to_reset_scene_path # path to the scene that has everything that needs resetting
var to_reset_scene # scene preloaded to be instantiated later on rollback

var player #reference to the current player
@export var timeToWaitBetweenCloneSpawns = 1.0

signal levelWon
signal levelLost
 
var currentCloneIndex = 0 # 0 if first player run, 1 if 2nd run meaning already a clone, etc
var clones : Array[Player]
var player_scene
var currentTimer

# vars that need reconnecting once I reset the level on rollback
var player_end

#to be called at the start and after every to_reset_scene reset
func instantiate_vars_and_connect_signals_on_to_reset_scene_ready():
	player_end = nodes_to_reset.get_node("PlayerEnd")
	player_end.endDoorReached.connect(_level_won)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_vars_and_connect_signals_on_to_reset_scene_ready()
	current_scene_path = get_tree().current_scene.scene_file_path
	to_reset_scene_path = str(current_scene_path.left(-5),"ToReset.tscn")
	to_reset_scene = load(to_reset_scene_path)
	
	player_scene = preload("res://Objects/Player.tscn")
	spawn_player()
	if not timers.is_empty(): start_timer_and_connect_signal(timers[0])
	player.rollbackSignal.connect(rollback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_level():
	pass

# Spawns player at start
func spawn_player():
	player = player_scene.instantiate()
	player.cloneIndex = currentCloneIndex
	player.position = player_start.position
	
	add_child(player)


#spawns clone and passes it current recording from player. Returns clone to be saved in var
#spawned clone instantly plays back the recordings
func spawn_clone():
	var clone = player_scene.instantiate()
	clone.cloneIndex = currentCloneIndex
	clone.position = player_start.position
	clone.recordedInputs = player.recordedInputs.duplicate(true)
	player.recordedInputs.clear()
	clone.isPlayingBack = 1
	
	add_child(clone)
	player_start.decrement_clones_left()
	
	
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
	
	currentCloneIndex += 1
	
	#if the rollback was manual I need to stop the current timer
	if currentTimer: currentTimer.timeout.disconnect(_on_timer_timeout)
	
	# reset and hide player and clones we already had
	player.position = player_start.position
	enable_disable_player_or_clone(player)
	for clone in clones:
		clone.position = player_start.position
		clone.playbackIndex = 0
		enable_disable_player_or_clone(clone)
	
	# reset interactables and animatables in level
	var new_to_reset_scene = to_reset_scene.instantiate()
	nodes_to_reset.queue_free()
	add_child(new_to_reset_scene)
	nodes_to_reset = new_to_reset_scene
	instantiate_vars_and_connect_signals_on_to_reset_scene_ready() #reconnect stuff to new scene
	
	#play the clones we already had
	for clone in clones:
		await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
		enable_disable_player_or_clone(clone)
		set_clone_opacity(clone)
	
	#spawn the newest clone
	await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
	clones.append(spawn_clone())
	set_clone_opacity(clones[-1])
	
	#enable player
	await get_tree().create_timer(timeToWaitBetweenCloneSpawns).timeout
	enable_disable_player_or_clone(player)
	
	#start the next timer
	if not timers.is_empty(): 
		if currentCloneIndex < timers.size():
			start_timer_and_connect_signal(timers[currentCloneIndex])

# hides/shows player/clone and enables/disables physics
func enable_disable_player_or_clone(playerOrClone):
	playerOrClone.visible = not playerOrClone.visible
	playerOrClone.collision_shape.disabled = not playerOrClone.collision_shape.disabled
	playerOrClone.set_physics_process(not playerOrClone.is_physics_processing())

func start_timer_and_connect_signal(seconds):
	currentTimer = Timer.new()
	currentTimer.one_shot = true
	currentTimer.wait_time = seconds
	add_child(currentTimer)
	currentTimer.timeout.connect(_on_timer_timeout)
	currentTimer.start()

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
	print(str("RIP, you lost"))
	levelLost.emit()
	get_tree().paused = true
