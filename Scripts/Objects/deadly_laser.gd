extends AnimatableBody2D

@export var laser_raycast_length := 500.0
@export var isEnabled := true
@onready var laser: RayCast2D = $laser
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var laser_sound: AudioStreamPlayer2D = $laserSound

signal deadly_laser_hit
signal laser_off

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.set_raycast_length(laser_raycast_length)
	laser.collided.connect(laser_collided)
	set_enabled(isEnabled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func laser_collided(body):
	deadly_laser_hit.emit(self, body)
	if body is Player:
		body.die()
	if body is LaserHitSurface:
		body._on_laser_hit(self)

func set_enabled(enabled): # 1 for enable, 0 for disabled
	isEnabled = enabled
	if isEnabled:
		animated_sprite_2d.play("on")
		laser_sound.pitch_scale = 1.0
		laser_sound.play()
	else:
		laser_off.emit(self)
		animated_sprite_2d.play("off")
		laser_sound.pitch_scale = 3.0
		laser_sound.play()
	laser.set_laser_enabled(isEnabled)
	
