extends Extra
#objects that can be picked up need to have their pivot in the middle
#so that when the objects get turned they are still at the right height

@export var offsetXDuringPickup := 25.0
var isPickedUp = 0
var objectNodeParent
var objectIsRigidBody = 0
var objectCollisionShape
var holder
var pickUpOffset
var old_gravity_scale = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objectNodeParent = objectNode.get_parent()
	objectIsRigidBody = objectNode is RigidBody2D
	if objectIsRigidBody:
		objectCollisionShape = objectNode.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isPickedUp and holder:
		var target_pos = holder.global_position + pickUpOffset
		var dir = target_pos - objectNode.global_position
		if dir.length() > 50:
			drop(holder)
		else:
			# Smooth follow
			objectNode.linear_velocity = dir * 10.0

func interactOne(callingPlayer: Player):
	if callingPlayer.isHoldingSomething and not isPickedUp:
		print("is holding something")
		return
	
	if isPickedUp:
		#we drop no matter if we're looking or not
		drop(callingPlayer)
	else:
		var lastDir = callingPlayer.lastDirection
		var isOnRightOfPlayer = callingPlayer.RightInteractRaycast.get_collider() == interactableNode
		var isOnLeftOfPlayer = callingPlayer.LeftInteractRaycast.get_collider() == interactableNode
		# we only pick up if looking at the object
		if (isOnRightOfPlayer and lastDir == 1) or (isOnLeftOfPlayer and lastDir == -1):
			pickUp(callingPlayer)

func pickUp(callingPlayer):
	if callingPlayer.isHoldingSomething:
		return
	
	callingPlayer.drop_all.connect(drop)
	callingPlayer.interactPressed.connect(drop_if_interact_one)
	
	pickUpOffset = getOffset(callingPlayer)
	isPickedUp = 1
	holder = callingPlayer
	callingPlayer.isHoldingSomething = 1
	if objectIsRigidBody:
		old_gravity_scale = objectNode.gravity_scale
		objectNode.gravity_scale = 0.0
		objectNode.linear_velocity = Vector2.ZERO
		objectNode.add_collision_exception_with(callingPlayer)
		callingPlayer.add_collision_exception_with(objectNode)

func getOffset(callingPlayer):
	var isOnRightSideOfPlayer = 1 if callingPlayer.RightInteractRaycast.get_collider() == interactableNode else -1
	var offset = isOnRightSideOfPlayer * Vector2(offsetXDuringPickup + 3, 0) + Vector2(0, -1)
	return offset

func drop(callingPlayer):
	isPickedUp = 0
	callingPlayer.isHoldingSomething = 0
	if objectIsRigidBody:
		objectNode.gravity_scale = old_gravity_scale
		if abs(callingPlayer.global_position.x - objectNode.global_position.x) < 15.0:
			callingPlayer.global_position.y += -10.0
		await get_tree().create_timer(0.01).timeout
		objectNode.remove_collision_exception_with(callingPlayer)
		callingPlayer.remove_collision_exception_with(objectNode)
	callingPlayer.drop_all.disconnect(drop)
	callingPlayer.interactPressed.disconnect(drop_if_interact_one)
	holder = null

func drop_if_interact_one(interactPressed):
	var one = interactPressed & 1
	if one:
		drop(holder)
