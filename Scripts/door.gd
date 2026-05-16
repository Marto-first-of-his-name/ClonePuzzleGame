extends AnimatableBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("closes")
	animated_sprite_2d.set_frame(31)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(collision_shape_2d.disabled)
	pass

func open_close_door(shouldOpen):
	if shouldOpen:
		if animated_sprite_2d.is_playing():
			play_anim_backward_from_current_frame()
		else:
			animated_sprite_2d.play("opens")
	else:
		enable_disable_collision(1)
		print("closed?")
		print(collision_shape_2d.disabled)
		if animated_sprite_2d.is_playing():
			play_anim_backward_from_current_frame()
		else:
			animated_sprite_2d.play("closes")

func play_anim_backward_from_current_frame():
	var current_animation = animated_sprite_2d.animation
	var current_playing_speed = animated_sprite_2d.get_playing_speed()
	var current_frame = animated_sprite_2d.get_frame()
	var current_progress = animated_sprite_2d.get_frame_progress()
	animated_sprite_2d.play(current_animation, 0.0 - current_playing_speed)
	animated_sprite_2d.set_frame_and_progress(current_frame, current_progress)

# only disable collision when door is FULLY open.
func _on_animated_sprite_2d_animation_finished() -> void:
	var current_animation = animated_sprite_2d.animation
	var current_frame = animated_sprite_2d.get_frame()
	
	if current_animation == "opens":
		if current_frame == 0: #door closed
			#enable_disable_collision(1)
			pass
		else: #door open
			enable_disable_collision(0)
		
	else: #current anim is closes
		if current_frame == 0: #door open
			enable_disable_collision(0)
		else: #door closed
			#enable_disable_collision(1)
			pass

func enable_disable_collision(shouldEnable):
	if shouldEnable:
		collision_shape_2d.set_deferred("disabled", false)
	else:
		collision_shape_2d.set_deferred("disabled", true)
