extends AnimatableBody2D

@export var isEnabled = true
@export var jumpPadStrength = 500
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ambient_sound: AudioStreamPlayer2D = $ambientSound
@onready var on_pad_sound: AudioStreamPlayer2D = $onPadSound

var last_ambient_sound_position := 0.0
var bodies_in_area_while_disabled = []

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
	for body in bodies_in_area_while_disabled:
		pad_stuff(body)

func set_animation():
	if isEnabled:
		animated_sprite_2d.play("enabled")
		ambient_sound.play(last_ambient_sound_position)
	else:
		animated_sprite_2d.play("disabled")
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
	if body is CharacterBody2D:
		body.velocity.y = -jumpPadStrength
	if body is RigidBody2D:
		body.linear_velocity.y = 0
		body.apply_central_impulse(Vector2(0,-jumpPadStrength-100))
	on_pad_sound.play()
