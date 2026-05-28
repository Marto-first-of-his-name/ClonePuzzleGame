extends AnimatableBody2D

@export var laser_raycast_length := 500.0
@onready var laser: RayCast2D = $laser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.set_raycast_length(laser_raycast_length)
	print(laser.rayCastLength)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
