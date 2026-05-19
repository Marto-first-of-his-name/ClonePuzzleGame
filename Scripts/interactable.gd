class_name Interactable extends Area2D
# I need to add this node to whatever I want to interact with e.g. a box. I add it right under the root
# Then I add a collision shape to this node.
# Then I can add any (up to three) of the Extras (pickUpExtra, activateExtra, etc) to this node.

var extras = []

#the interact inputs need to be stored on the player, not here
	#since the clones need to save them too in the records

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#store all children nodes (except the CollisionShape2d) in array
	var children = get_children()
	var extrasIndex = 0
	for child in children:
		if child.name.right(5)=="Extra":
			extras[extrasIndex] = child
			extrasIndex += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func call_interaction(interactIndexBinary): #have player call this when inputs are pressed
	var one = interactIndexBinary & 1
	var two = interactIndexBinary >> 1 & 1
	var three = interactIndexBinary >> 2 & 1
	for extra in extras:
		if one and extra.interactOneAvailable:
			extra.interactOne()
		if two and extra.interactTwoAvailable:
			extra.interactTwo()
		if three and extra.interactThreeAvailable:
			extra.interactThree()
