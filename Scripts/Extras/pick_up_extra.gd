extends Extra

@export var offsetXDuringPickup := 25.0
var isPickedUp = 0
var objectNodeParent
var objectIsRigidBody = 0
var objectCollisionShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objectNodeParent = objectNode.get_parent()
	objectIsRigidBody = objectNode is RigidBody2D
	if objectIsRigidBody:
		objectCollisionShape = objectNode.get_child(0)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interactOne(callingPlayer: Player):
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
	callingPlayer.drop_all.connect(drop)
	objectNode.reparent(callingPlayer)
	objectNode.global_position = callingPlayer.global_position + getOffset(callingPlayer)
	isPickedUp = 1
	callingPlayer.isHoldingSomething = 1
	if objectIsRigidBody:
		objectNode.freeze = true
		objectCollisionShape.reparent(callingPlayer)

func getOffset(callingPlayer):
	var isOnRightSideOfPlayer = 1 if callingPlayer.RightInteractRaycast.get_collider() == interactableNode else -1
	var offset = isOnRightSideOfPlayer * Vector2(offsetXDuringPickup + 3, 0) + Vector2(0, 10)
	return offset

func drop(callingPlayer):
	if objectIsRigidBody:
		objectNode.freeze = false
		objectCollisionShape.reparent(objectNode)
		objectNode.move_child(objectCollisionShape,0)
	objectNode.reparent(objectNodeParent)
	isPickedUp = 0
	callingPlayer.isHoldingSomething = 0
