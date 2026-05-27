extends AnimatableBody2D

@export var isActive = true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_animation()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate():
	isActive = not isActive
	set_animation()

func set_animation():
	if isActive:
		animated_sprite_2d.play("active")
	else:
		animated_sprite_2d.play("inactive")
