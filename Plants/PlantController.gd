extends Node2D

export (float)var status1 = 10;
export (float)var status2 = 10;
export (float)var status3 = 10;

signal plant_tapped
signal plant_slash
signal plant_hold_down
signal plant_hold_up

var isHolding
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
				print("Tap Plant")
				isHolding = true
				emit_signal("plant_hold_down")
				emit_signal("plant_tapped")
		if(!event.is_pressed() && isHolding):
			isHolding=false
			emit_signal("plant_hold_up")
			var point = event.position
			print("Tap up Plant")
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
		if(slashedPlant && event.speed.length() > 700):
			emit_signal("plant_slash")
			print("Slash Plant")
