class_name Extra extends Node

#Node name must end in "Extra"

@onready var interactableNode = get_parent() #the interactable node that is under objectNode
@onready var interactableCollisionShape = interactableNode.get_child(0)
@onready var objectNode = interactableNode.get_parent() #the actual object that we want to interact with

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interactOne(callingPlayer):
	pass

func interactTwo(callingPlayer):
	pass

func interactThree(callingPlayer):
	pass
