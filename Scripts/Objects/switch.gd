extends AnimatableBody2D

@export var isOn = false #switch starts on the left # left should always be off state
# start on the right instead if object is on already
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var targets: Array[Node]
@export var methodNames: Array[String] #methodNames[i] needs to belong to targets[i]
									#if i want to call multiple methods from one it is also doable
									#by adding the target multiple times


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_animation()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# actionToDo is a bool: 1 does one action, 0 the other. E.g. 1 opens door, 0 closes it.
func trigger(actionToDo):
	for i in targets.size():
		if targets[i] and targets[i].has_method(methodNames[i]):
			targets[i].call(methodNames[i], actionToDo)
		else:
			print(str("no target or target has no method called ", methodNames[i]))

func activate():
	isOn = not isOn
	trigger(isOn) # this works coz if isLeft==1 then we're on the left (meaning off) and we want to send the on (meaning 1) signal
	set_animation()

func set_animation():
	if isOn:
		animated_sprite_2d.play("right")
	else:
		animated_sprite_2d.play("left")
