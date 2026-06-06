extends Node2D


@onready var levels_container: VBoxContainer = $Control/levelsContainer

var level_path_prefix = "res://Levels/"
var level_path_suffix = ".tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels = Global.game_controller.levels
	var index = 0
	for level in levels:
		var level_path = str(level_path_prefix, level, level_path_suffix)
		var button = Button.new()
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.text = str("Level ", index + 1, ": ", level)
		button.pressed.connect(_level_button_pressed.bind(level_path, index))
		levels_container.add_child(button)
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _level_button_pressed(level_path, level_index):
	Global.game_controller.delete_current_gui()
	Global.game_controller.add_level_scene(level_path)
	Global.game_controller.currentLevelIndex = level_index
	
