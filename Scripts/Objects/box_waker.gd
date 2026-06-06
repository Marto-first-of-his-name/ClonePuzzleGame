extends Node2D

@export var bodies: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for body in bodies:
		body.sleeping_state_changed.connect(wake_up_sleeping_body.bind(body))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func wake_up_sleeping_body(body):
		body.sleeping = false
