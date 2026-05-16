extends AnimatableBody2D

@export var maxClonesForLevel: int
@onready var label: Label = $Label

var clonesLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_clones_left(maxClonesForLevel)

func update_clones_left(clonesLeftParam):
	clonesLeft = clonesLeftParam
	label.text = str(clonesLeft)

func decrement_clones_left():
	update_clones_left(clonesLeft - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
