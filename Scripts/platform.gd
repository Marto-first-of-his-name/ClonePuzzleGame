extends AnimatableBody2D

@onready var left_tile: Sprite2D = $LeftTile
@onready var middle_tile: Sprite2D = $MiddleTile
@onready var right_tile: Sprite2D = $RightTile
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var length_in_tiles:= 3 #left middle and right makes the minimum be 3
var offset_per_middle_tile = Vector2(16.0, 0.0)
var offset_right_tile = Vector2(12.0, 0.0)

# if you are looking for the animation, it's not done here
# it's done by adding an animation player under the platform node in the actual level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_middle_tiles()
	adjust_collision()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_middle_tiles():
	var added_tiles_count = length_in_tiles - 3
	var current_tile_position = Vector2(16.0, -5.0)
	for i in added_tiles_count:
		current_tile_position += offset_per_middle_tile
		var new_middle_tile = middle_tile.duplicate()
		add_child(new_middle_tile)
		new_middle_tile.position = current_tile_position
	right_tile.position = current_tile_position + offset_right_tile#place right tile at the end

func adjust_collision():
	collision_shape_2d.scale = Vector2(2 + 2 * (length_in_tiles - 2), 1.0)
	collision_shape_2d.position = Vector2((8 * 2 + 16 * (length_in_tiles - 2) )/ 2, -5.0)
