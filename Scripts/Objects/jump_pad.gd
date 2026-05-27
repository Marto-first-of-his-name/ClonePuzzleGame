extends AnimatableBody2D

@export var isEnabled = true
@export var jumpPadStrength = 500
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_animation()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func enable(shouldEnable):
	isEnabled = shouldEnable
	set_animation()

func set_animation():
	if isEnabled:
		animated_sprite_2d.play("enabled")
	else:
		animated_sprite_2d.play("disabled")

# something touches the pad
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isEnabled:
		return
	if body is CharacterBody2D:
		body.velocity.y = -jumpPadStrength
	if body is RigidBody2D:
		body.linear_velocity.y = 0
		body.apply_central_impulse(Vector2(0,-jumpPadStrength))
