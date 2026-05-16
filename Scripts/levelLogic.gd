extends Node2D

@export var timers: Array[float]

@onready var player_start: Node2D = $PlayerStart
@onready var player_end: Node2D = $PlayerEnd
@onready var maxClonesForLevel = player_start.maxClonesForLevel

var player #reference to the current player
@export var timeToWaitBetweenCloneSpawns = 1.0

signal levelWon
signal gameLost
 
var currentCloneIndex = 0 # 0 if first player run, 1 if 2nd run meaning already a clone, etc
var clones : Array[Player]
var player_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_scene = preload("res://Objects/Player.tscn")
	spawn_player()
	player.rollbackSignal.connect(_rollback)
	player_end.endDoorReached.connect(_levelWon)

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
	var opacity = 1 - 0.2 * (currentCloneIndex - clone.cloneIndex + 1)
	clone.PlayerSprite.modulate = Color(1,1,1,opacity)

func _rollback():
	if currentCloneIndex >= maxClonesForLevel:
		print("can't rollback coz reached limit")
		return
	
	currentCloneIndex += 1
	
	# reset and hide player and clones we already had
	player.position = player_start.position
	enable_disable_player_or_clone(player)
	for clone in clones:
		clone.position = player_start.position
		clone.playbackIndex = 0
		enable_disable_player_or_clone(clone)
	
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

# hides/shows player/clone and enables/disables physics
func enable_disable_player_or_clone(playerOrClone):
	playerOrClone.visible = not playerOrClone.visible
	playerOrClone.collision_shape.disabled = not playerOrClone.collision_shape.disabled
	playerOrClone.set_physics_process(not playerOrClone.is_physics_processing())

#body is the body that entered the door at the end
func _levelWon(body):
	print(str("good job, you won by reaching the door with ", body.cloneIndex))
	body.queue_free()
	levelWon.emit()
	get_tree().paused = true
