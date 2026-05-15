extends Node2D

@onready var player_start: Node2D = $PlayerStart
@onready var player = $Player

var currentCloneIndex = 0 # 0 if first player run, 1 if 2nd run meaning already a clone, etc
var clones : Array[Player]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	clones.append(spawn_clone())
	set_clones_opacity()
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#spawns clone and passes it current recording from player. Returns clone to be saved in var
func spawn_clone():
	var player_scene = preload("res://Objects/Player.tscn")

	var clone = player_scene.instantiate()
	currentCloneIndex += 1
	clone.cloneIndex = currentCloneIndex
	clone.position = player_start.position + Vector2(0, -20.0)
	clone.recordedInputs = player.recordedInputs.duplicate(true)
	
	add_child(clone)
	player_start.clonesLeft -= 1
	
	return clone

func set_clones_opacity():
	for clone in clones:
		var opacity = 1 - 0.2 * (currentCloneIndex - clone.cloneIndex + 1)
		clone.PlayerSprite.modulate = Color(1,1,1,opacity)
