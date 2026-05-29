extends Node2D
@onready var next_button: Button = $Control/NextButton

var level_path_prefix = "res://Levels/"
var level_path_suffix = ".tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	Global.game_controller.replace_current_level(Global.game_controller.currentLevelScene.scene_file_path)
	Global.game_controller.add_remove_level_won(0)


func _on_next_button_pressed() -> void:
	Global.game_controller.currentLevelIndex += 1
	if Global.game_controller.currentLevelIndex >= Global.game_controller.levels.size():
		next_button.disabled = true	
		return
	get_tree().paused = false
	Global.game_controller.replace_current_level(str(level_path_prefix, Global.game_controller.levels[	Global.game_controller.currentLevelIndex] , level_path_suffix))
	Global.game_controller.add_remove_level_won(0)


func _on_main_menu_button_pressed() -> void:
	Global.game_controller.delete_current_level()
	get_tree().paused = false
	Global.game_controller.add_gui_scene("res://UI/main_menu.tscn")
	Global.game_controller.add_remove_level_won(0)


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
