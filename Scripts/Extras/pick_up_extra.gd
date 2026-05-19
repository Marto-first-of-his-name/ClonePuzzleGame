extends Extra

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactOneAvailable = 1
	interactTwoAvailable = 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interactOne():
	print("interact one")

func interactTwo():
	print("interact two")

func interactThree():
	print("interact three")
