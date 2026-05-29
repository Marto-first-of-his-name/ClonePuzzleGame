extends Node2D
var level_select_path = "res://UI/level_select.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree().root.get_child(0).name)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(level_select_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
