extends AnimationPlayer
#this code can work with things that send a simple yes/no signal where yes plays the animation
#forward, and no backwards.
#E.g. platform controlled by button or lever


@onready var animation_to_play = get_animation_list()[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if animation_to_play == "RESET" and get_animation_list().size()>1:
		animation_to_play = get_animation_list()[1]
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate(forward): #1 if we play the animation forward, 0 if backwards
	if forward:
		if is_playing():
			play_anim_backward_from_current_frame()
		else:
			play_anim_normally()
	else:
		if is_playing():
			play_anim_backward_from_current_frame()
		else:
			play_backwards(animation_to_play)

func play_anim_backward_from_current_frame():
	var current_playing_speed = get_playing_speed()
	var current_time = current_animation_position
	speed_scale = 0.0 - current_playing_speed
	play(animation_to_play)
	seek(current_time, true)

func play_anim_normally():
	speed_scale = 1.0
	play(animation_to_play)
	seek(0, true)
