extends AnimatableBody2D

@export var isEnabled = true
@export var jumpPadStrength = 500
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ambient_sound: AudioStreamPlayer2D = $ambientSound
@onready var on_pad_sound: AudioStreamPlayer2D = $onPadSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var last_ambient_sound_position := 0.0
var bodies_in_area_while_disabled = []
var pad_direction
var restricted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rotation != 0.0:
		restricted = true
		collision_shape_2d.disabled = true
		area_collision_shape_2d.shape.size.x = 20.0
		area_collision_shape_2d.shape.size.y = 18.0
	set_animation()
	pad_direction = Vector2.UP.rotated(rotation)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func enable(shouldEnable):
	isEnabled = shouldEnable
	set_animation()
	for body in bodies_in_area_while_disabled:
		pad_stuff(body)

func set_animation():
	if isEnabled:
		if restricted:
			animated_sprite_2d.play("restricted_enabled")
		else:
			animated_sprite_2d.play("normal_enabled")
		ambient_sound.play(last_ambient_sound_position)
	else:
		if restricted:
			animated_sprite_2d.play("restricted_disabled")
		else:
			animated_sprite_2d.play("normal_disabled")
		last_ambient_sound_position = ambient_sound.get_playback_position()
		ambient_sound.stop()

# something touches the pad
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isEnabled:
		if body is CharacterBody2D or RigidBody2D:
			bodies_in_area_while_disabled.append(body)
		return
	pad_stuff(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bodies_in_area_while_disabled:
		bodies_in_area_while_disabled.erase(body)


func pad_stuff(body):
	body.position = position
	if body is Player:
		if restricted:
			#if body.currentState == "dash":
				#print("Was dashing")
				#body.set_state(body.previousState)
			body.set_state("fall")
			body.isAirMovementLocked = 1
		body.canDash = false
		body.velocity.x = jumpPadStrength * pad_direction.x
		body.velocity.y = jumpPadStrength * pad_direction.y
	if body is RigidBody2D:
		body.linear_velocity = Vector2.ZERO
		body.apply_central_impulse((jumpPadStrength+100) * pad_direction)
	on_pad_sound.play()
