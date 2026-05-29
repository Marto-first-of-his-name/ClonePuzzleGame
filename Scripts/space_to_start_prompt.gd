extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start level"):
		print("hello")
	var current_scene = Global.game_controller.currentLevelScene
	if Input.is_action_just_pressed("start level") and current_scene:
		if current_scene is GameLevel and current_scene.isLevelReadyToStart:
			get_tree().paused = false
			current_scene.start_level()
			Global.game_controller.delete_current_gui()
