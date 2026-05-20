extends Extra


var isPickedUp = 0
var objectNodeParent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objectNodeParent = objectNode.get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interactOne(callingPlayer: Player):
	print("trying to pick up")
	if callingPlayer.isHoldingSomething and not isPickedUp:
		return
	
	if isPickedUp:
		drop(callingPlayer)
	else:
		pickUp(callingPlayer)

func pickUp(callingPlayer):
	if objectNode is RigidBody2D:
		objectNode.freeze = true
	objectNode.reparent(callingPlayer)
	objectNode.global_position = callingPlayer.global_position + Vector2(20, 0)
	isPickedUp = 1
	callingPlayer.isHoldingSomething = 1

func drop(callingPlayer):
	if objectNode is RigidBody2D:
		objectNode.freeze = false
	objectNode.reparent(objectNodeParent)
	isPickedUp = 0
	callingPlayer.isHoldingSomething = 0
