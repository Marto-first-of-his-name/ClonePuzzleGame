extends AnimatableBody2D

var isPressed = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var target: Node
@export var methodName: String

var bodiesPressing: Array[PhysicsBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("idle")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# activate is a bool: 1 does one action, 0 the other. E.g. 1 opens door, 0 closes it.
func trigger(activate):
	if target and target.has_method(methodName):
		target.call(methodName, activate)
	else:
		print(str("no target or target has no method called ", methodName))

func set_pressed():
	var buttonShouldBePressed = not bodiesPressing.is_empty()
	if buttonShouldBePressed and not isPressed: #i.e. state change from idle to pressed
		isPressed = 1
		trigger(1)
		animated_sprite_2d.play("pressed")
	elif not buttonShouldBePressed and isPressed: #i.e. state change from pressed to idle
		isPressed = 0
		trigger(0)
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
