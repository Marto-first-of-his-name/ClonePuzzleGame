extends Node2D

var currentGUIScene
var currentLevelScene

var levelLost
var levelWon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#instantiate the nodes we'll need all the time
	levelLost = load("res://UI/level_lost.tscn").instantiate()
	levelWon = load("res://UI/level_won.tscn").instantiate()
	
	var main_menu = preload("res://UI/main_menu.tscn")
	currentGUIScene = main_menu.instantiate()
	add_child(currentGUIScene)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func delete_current_gui():
	if currentGUIScene:
		currentGUIScene.queue_free()

func delete_current_level():
	if currentLevelScene:
		currentLevelScene.queue_free()

func add_gui_scene(scenePath):
	currentGUIScene = load(scenePath).instantiate()
	add_child(currentGUIScene)

func add_level_scene(scenePath):
	currentLevelScene = load(scenePath).instantiate()
	add_child(currentGUIScene)

func add_remove_level_lost(shouldAdd): #1 if should add, 0 if should remove
	if shouldAdd:
		add_child(levelLost)
	else:
		remove_child(levelLost)

func add_remove_level_won(shouldAdd): #1 if should add, 0 if should remove
	if shouldAdd:
		add_child(levelWon)
	else:
		remove_child(levelWon)
