extends AnimatableBody2D


@export var targets: Array[Node]
@export var methodNames: Array[String] #methodNames[i] needs to belong to targets[i]
									#if i want to call multiple methods from one it is also doable
									#by adding the target multiple times

@onready var laser_hit_surface: LaserHitSurface = $LaserHitSurface
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser_hit_surface.targets = targets
	laser_hit_surface.methodNames = methodNames
	animated_sprite_2d.play("off")
	laser_hit_surface.activeChanged.connect(_on_active_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_active_changed(isActive):
	print("signal received")
	if isActive:
		animated_sprite_2d.play("on")
	else:
		animated_sprite_2d.play("off")
