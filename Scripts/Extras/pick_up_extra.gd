extends Extra


var isPickedUp = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	isPickedUp = 1
	callingPlayer.isHoldingSomething = 1

func drop(callingPlayer):
	isPickedUp = 0
	callingPlayer.isHoldingSomething = 1
