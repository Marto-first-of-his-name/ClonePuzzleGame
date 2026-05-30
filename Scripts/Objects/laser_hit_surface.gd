class_name LaserHitSurface extends AnimatableBody2D


var isActive = 0 #should always start inactive
var lasersHitting = []
signal activeChanged

var targets: Array[Node]
var methodNames: Array[String] #methodNames[i] needs to belong to targets[i]
									#if i want to call multiple methods from one it is also doable
									#by adding the target multiple times

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_activated()
	lasersHitting.clear()
	print(isActive)

# something touches the laser's surface
func _on_laser_hit(laser):
	if laser not in lasersHitting:
		lasersHitting.append(laser)


# activate is a bool: 1 does one action, 0 the other. E.g. 1 opens door, 0 closes it.
func trigger(activate):
	for i in targets.size():
		if targets[i] and targets[i].has_method(methodNames[i]):
			targets[i].call(methodNames[i], activate)
		else:
			print(str("no target or target has no method called ", methodNames[i]))

func set_activated():
	var laserShouldBeActive = not lasersHitting.is_empty()
	if laserShouldBeActive and not isActive: #i.e. state change from off to on
		isActive = 1
		trigger(1)
		activeChanged.emit(isActive)
	elif not laserShouldBeActive and isActive: #i.e. state change from on to off
		isActive = 0
		trigger(0)
		activeChanged.emit(isActive)
