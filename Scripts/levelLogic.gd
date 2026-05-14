extends Node2D

@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	spawn_clone()
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#spawns clone and passes it current recording from player
func spawn_clone():
	var player_scene = preload("res://Objects/Player.tscn")

	var clone = player_scene.instantiate()

	clone.isClone = 1
	clone.position = Vector2(220.0, 177.0)
	clone.recordedInputs = player.recordedInputs
	
	add_child(clone)
