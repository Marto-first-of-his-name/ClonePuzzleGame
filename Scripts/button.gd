extends AnimatableBody2D

var isPressed = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var bodiesPressing: Array[PhysicsBody2D]

signal buttonInteracted # args 1 for pressed and 0 for released

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_pressed():
	var buttonShouldBePressed = not bodiesPressing.is_empty()
	if buttonShouldBePressed and not isPressed: #i.e. state change from idle to pressed
		isPressed = 1
		buttonInteracted.emit(1)
		animated_sprite_2d.play("pressed")
	elif not buttonShouldBePressed and isPressed: #i.e. state change from pressed to idle
		isPressed = 0
		buttonInteracted.emit(0)
		animated_sprite_2d.play("idle")

# something touches the button's top
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D:
		bodiesPressing.append(body)
		set_pressed()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bodiesPressing:
		bodiesPressing.erase(body)
		set_pressed()
