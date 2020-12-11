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
var max_visibility = 0.7
# Called when the node enters the scene tree for the first time.
func _ready():
	if(healthy_fertilizer > 0):
		$Flowers.modulate.a = 0
	if(healthy_kills == 0):
		$Bugs.modulate.a = 0
	if(healthy_water == 0):
		$Dried.modulate.a = 0
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


func is_healthy():
	return Fertilizer >= healthy_fertilizer\
		   && Branches >= healthy_branches\
		   && Water >= healthy_water\
		   && Bugspray >= healthy_kills

func update_status(status_id, increment):
	if status_id == 0:
		Fertilizer += increment
		$Flowers.modulate.a = max_visibility*(float(Fertilizer)/healthy_fertilizer)
		if(Fertilizer >= healthy_fertilizer):
			$Flowers.modulate.a=1
	elif status_id == 1:
		if(increment!= -1):
			Branches += 1
			var branchAsset = $Leaves.get_children()[increment+1]
			var branchCol = $Leaves.get_child(0).get_children()[increment]
			$Leaves.remove_child(branchAsset)
			$FallingLeaves.add_child(branchAsset)
			$Leaves.get_child(0).remove_child(branchCol)
	elif status_id == 2:
		Water += increment
		$Dried.modulate.a = 1- max_visibility*(float(Water)/healthy_water)
		if Water >= healthy_water:
			$Dried.modulate.a = 0
	elif status_id == 3:
		Bugspray += increment
		$Bugs.modulate.a = 1- max_visibility*(float(Bugspray)/healthy_kills)
		if Bugspray >= healthy_kills:
			$Bugs.modulate.a = 0
	pass

func disable():
	set_process_input(false)
	hide()

func enable():
	set_process_input(true)
	show()
