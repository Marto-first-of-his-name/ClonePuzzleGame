class_name GameController extends Node2D

@export var levels: Array[String]

@onready var levels_node: Node2D = $Levels
@onready var gui: Node2D = $GUI

var currentGUIScene
var currentLevelScene
var currentLevelIndex

var levelLost
var levelWon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	
	#instantiate the nodes we'll need all the time
	levelLost = load("res://UI/level_lost.tscn").instantiate()
	levelWon = load("res://UI/level_won.tscn").instantiate()
	
	var main_menu = preload("res://UI/main_menu.tscn")
	currentGUIScene = main_menu.instantiate()
	gui.add_child(currentGUIScene)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func replace_current_gui(scenePath):
	delete_current_gui()
	add_gui_scene(scenePath)

func replace_current_level(scenePath):
	delete_current_level()
	add_level_scene(scenePath)

func add_gui_scene(scenePath):
	currentGUIScene = load(scenePath).instantiate()
	gui.add_child(currentGUIScene)

func delete_current_gui():
	if currentGUIScene:
		currentGUIScene.queue_free()

func add_level_scene(scenePath):
	currentLevelScene = load(scenePath).instantiate()
	levels_node.add_child(currentLevelScene)
	#pause and only unpause when player ready

func delete_current_level():
	if currentLevelScene:
		currentLevelScene.queue_free()

func add_remove_level_lost(shouldAdd): #1 if should add, 0 if should remove
	if shouldAdd:
		gui.add_child(levelLost)
	else:
		gui.remove_child(levelLost)

func add_remove_level_won(shouldAdd): #1 if should add, 0 if should remove
	if shouldAdd:
		gui.add_child(levelWon)
	else:
		gui.remove_child(levelWon)
