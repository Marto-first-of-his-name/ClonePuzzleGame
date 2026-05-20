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
		#we drop no matter if we're looking or not
		drop(callingPlayer)
	else:
		var lastDir = callingPlayer.lastDirection
		var isOnRightOfPlayer = callingPlayer.RightInteractRaycast.get_collider() == interactableNode
		# we only pick up if looking at the object
		if (isOnRightOfPlayer and lastDir == 1) or (not isOnRightOfPlayer and lastDir == -1):
			pickUp(callingPlayer)

func pickUp(callingPlayer):
	#rewrite this so the object just tries to follow the ideal position, that way it still collides with stuff
	#(animate or move_and_collide)
	if objectNode is RigidBody2D:
		objectNode.freeze = true
	objectNode.reparent(callingPlayer)
	objectNode.global_position = callingPlayer.global_position + getOffset(callingPlayer)
	isPickedUp = 1
	callingPlayer.isHoldingSomething = 1

func getOffset(callingPlayer):
	var isOnRightSideOfPlayer = 1 if callingPlayer.RightInteractRaycast.get_collider() == interactableNode else -1
	var offset = isOnRightSideOfPlayer * Vector2(25, 0)
	return offset

func drop(callingPlayer):
	if objectNode is RigidBody2D:
		objectNode.freeze = false
	objectNode.reparent(objectNodeParent)
	isPickedUp = 0
	callingPlayer.isHoldingSomething = 0
