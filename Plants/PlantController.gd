extends Node2D

export (float)var status0 = 0;
export (float)var status1 = 0;
export (float)var status2 = 0;
export (float)var status3 = 0;
export (float)var healthy_limit0 = 10;
export (float)var healthy_limit1 = 10;
export (float)var healthy_limit2 = 10;
export (float)var healthy_limit3 = 10;

signal plant_tapped
signal plant_slash
signal plant_hold_down
signal plant_hold_up

var isHolding
var healthy_emmited = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if (event is InputEventScreenTouch):
		if(event.is_pressed()):
			var point = event.position
			var space_state = get_world_2d().direct_space_state
			var collidersTouched = space_state.intersect_point(point, 32, [],
													 2147483647, false,true)
			var touchPlant = false
			for dict in collidersTouched:
				if (dict.collider == $Plant):
					touchPlant = true
					break
			if(touchPlant):
				isHolding = true
				emit_signal("plant_hold_down", $".")
				emit_signal("plant_tapped", $".")
		if(!event.is_pressed() && isHolding):
			isHolding=false
			emit_signal("plant_hold_up", $".")
			var point = event.position
	if( event is InputEventScreenDrag):
		var point = event.position
		var space_state = get_world_2d().direct_space_state
		var collidersTouched = space_state.intersect_point(point, 32, [],
													 2147483647, false,true)
		var slashedPlant = false
		for dict in collidersTouched:
			if (dict.collider == $Leaves/Leaf):
				slashedPlant = true
				break
		if(slashedPlant && event.speed.length() > 500):
			emit_signal("plant_slash", $".")


func is_healthy():
	return status0 > healthy_limit0\
		   && status1 > healthy_limit1\
		   && status2 > healthy_limit2\
		   && status3 > healthy_limit3

func update_status(status_id, increment):
	if status_id == 0:
		status0 += increment
	elif status_id == 1:
		status1 += increment
	elif status_id == 2:
		status2 += increment
	elif status_id == 3:
		status3 += increment
	pass

func disable():
	set_process_input(false)
	hide()

func enable():
	set_process_input(true)
	show()
