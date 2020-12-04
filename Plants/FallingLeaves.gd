extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


func _process(delta):
	for fallen_leaf in $".".get_children():
		fallen_leaf.position.y += 200*delta
		fallen_leaf.rotate(delta)
		fallen_leaf.modulate.a -= 1.5*delta
	for deletable_leaf in $".".get_children():
		if(deletable_leaf.position.y > 300):
			$".".remove_child(deletable_leaf)
