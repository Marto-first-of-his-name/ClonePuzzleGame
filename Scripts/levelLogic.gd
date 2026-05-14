extends Node2D

@onready var player = $Player

var clone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	clone = spawn_clone()
	var newframe = InputFrame.new()
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#spawns clone and passes it current recording from player. Returns clone to be saved in var
func spawn_clone():
	var player_scene = preload("res://Objects/Player.tscn")

	var clone = player_scene.instantiate()

	clone.isClone = 1
	clone.position = Vector2(220.0, 177.0)
	clone.recordedInputs = player.recordedInputs.duplicate(true)
	
	add_child(clone)
	return clone
