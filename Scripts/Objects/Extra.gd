class_name Extra extends Node

#Node name must end in "Extra"
var interactOneAvailable := 0
var interactTwoAvailable := 0
var interactThreeAvailable := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interactOne():
	print("interact one not defined")

func interactTwo():
	print("interact two not defined")

func interactThree():
	print("interact three not defined")
