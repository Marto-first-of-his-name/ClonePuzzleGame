class_name LaserHitSurface extends AnimatableBody2D


var isActive = 0 #should always start inactive
var lasersHitting = []
var lasersThatHaveHitBefore =[] #important to know when a laser leaves
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
	#print(isActive)
	pass

# a laser touches the surface
func _on_laser_hit(laser):
	if laser not in lasersThatHaveHitBefore: #only matters the first time it hits so we can connect signals
		lasersThatHaveHitBefore.append(laser)
		laser.deadly_laser_hit.connect(_on_laser_hit_anything)
		laser.laser_off.connect(_on_laser_off)
		_on_laser_hit_anything(laser, self) #call this the first time because the first signal got emitted before we were connected

#a laser that has previously touched this surface touches anything (could be this again or something else)
func _on_laser_hit_anything(laser, bodyThatGotHit):
	if bodyThatGotHit == self:
		if laser not in lasersHitting:
			lasersHitting.append(laser)
			set_activated()
	else: #i.e. the laser got blocked
		if laser in lasersHitting:
			lasersHitting.erase(laser)
			set_activated()

func _on_laser_off(laser):
	if laser in lasersHitting:
			lasersHitting.erase(laser)
			set_activated()


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
