extends RayCast2D

@export var rayCastLength := 100.0

@onready var line_2d: Line2D = $Line2D

signal collided(body)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_raycast_length(rayCastLength)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if is_colliding():
		collided.emit(get_collider())
		print(str("global pos: ", global_position))
		print(str("collis point: ", get_collision_point()))
		set_line_end_global(get_collision_point())
	else:
		set_line_end_local(target_position)

func set_raycast_length(length):
	rayCastLength = length
	target_position.x = rayCastLength

func set_line_end_local(endPointLocal):
	line_2d.set_point_position(1, endPointLocal)

func set_line_end_global(endPointglobal):
	line_2d.set_point_position(1, to_local(endPointglobal))
