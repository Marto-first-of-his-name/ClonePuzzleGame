extends Node2D

var currentLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tutorial3_scene = preload("res://Levels/Tutorial3Timer.tscn")
	currentLevel = tutorial3_scene.instantiate()
	add_child(currentLevel)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
