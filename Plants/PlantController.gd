extends Node2D

export (float)var status1 = 10;
export (float)var status2 = 10;
export (float)var status3 = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if (event is InputEventScreenTouch and event.is_pressed()):
		var point = event.position
		var space_state = get_world_2d().direct_space_state
		print(space_state.intersect_point(point))
		print (point)
