extends Node2D

export (float)var Fertilizer = 0
export (float)var Branches = 0
export (float)var Water = 0
export (float)var Bugspray = 0
export (float)var healthy_fertilizer = 10
export (float)var healthy_branches = 3
export (float)var healthy_water = 1.6
export (float)var healthy_kills = 1.6

signal plant_tapped
signal plant_slash
signal plant_hold_down
signal plant_hold_up

var isHolding
var healthy_emmited = false
var slashedIndex = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	if(healthy_fertilizer > 0):
		$Flowers.hide()
	if(healthy_kills == 0):
		$Bugs.hide()
	if(healthy_water == 0):
		$Dried.hide();
	for i in range(10):
		var branchAsset = $Leaves.find_node("Branch%d"%[i])
		if(!branchAsset):
			break
		if(i < healthy_branches):
			continue
		if(healthy_branches <= i):
			if(branchAsset):
				var branchCol = $Leaves/Colliders.find_node("Colliders%dCollider"% [i])
				$Leaves.remove_child(branchAsset)
				$Leaves/Colliders.remove_child(branchCol)
			else:
				break
	
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
		var collidersTouched = space_state.intersect_point(point, 32, [$Plant],
													 2147483647, false,true)
		var slashedPlant = false
		for dict in collidersTouched:
			if (dict.collider == $Leaves/Colliders):
				slashedPlant = true
				slashedIndex = dict.shape
				break
		if(slashedPlant && event.speed.length() > 300):
			emit_signal("plant_slash", $".")


func is_healthy():
	return Fertilizer >= healthy_fertilizer\
		   && Branches >= healthy_branches\
		   && Water >= healthy_water\
		   && Bugspray >= healthy_kills

func update_status(status_id, increment):
	if status_id == 0:
		Fertilizer += increment
		if(Fertilizer >= healthy_fertilizer):
			$Flowers.show()
	elif status_id == 1:
		if(slashedIndex!= -1):
			Branches += increment
			var branchAsset = $Leaves.get_children()[slashedIndex]
			var branchCol = $Leaves/Colliders.get_children()[slashedIndex]
			$Leaves.remove_child(branchAsset)
			$Leaves/Colliders.remove_child(branchCol)
			slashedIndex = -1
	elif status_id == 2:
		Water += increment
		if Water >= healthy_water:
			$Dried.hide()
	elif status_id == 3:
		Bugspray += increment
		if Bugspray >= healthy_kills:
			$Bugs.hide()
	pass

func disable():
	set_process_input(false)
	hide()

func enable():
	set_process_input(true)
	show()
