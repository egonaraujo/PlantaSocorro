extends Control

var index = 0

var anim_time = 0

var orig_pos_x
var orig_pos_bar_y

var center_x = 400
var center_y = 278
var radius = 40

var plant :Node2D
var backupPlantLeaves :Node2D
var workstation : Node2D
var plantTimer = 0
var plantHealthy = false


# Called when the node enters the scene tree for the first time.
func _ready():
	orig_pos_x = $"hand-tilt".get_position().x
	orig_pos_bar_y = $"hand-stroke".get_position().y
	
	plant = $PracticeTutorial/Workstation/Plants/Cactus
	backupPlantLeaves = plant.get_node("Leaves").duplicate()
	workstation = $PracticeTutorial/Workstation
	workstation.connect("plant_healthy",self,"_plantHealthy")
	workstation.set_process_input(false)
	workstation.ActivePlant = plant
	pass # Replace with function body.


func _plantHealthy(var plantname):
	plantHealthy= true
	plantTimer=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(plantHealthy):
		plantTimer += delta
		if(plantTimer > 0.7):
			plantTimer = 0
			plantHealthy=false
			_on_Next_pressed()
	anim_time = anim_time + delta
	if index == 0:
		var anim_end = 1
		var pos = $"hand-tilt".get_position()
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var offset =  119*per_cent
		$"hand-tilt".set_position(Vector2(orig_pos_x + offset, pos.y))
		$"hand-stroke".set_position(Vector2(orig_pos_x -15 + offset/2, orig_pos_bar_y))
		$"hand-stroke".set_scale(Vector2(per_cent, 1.0))
		if anim_time > anim_end:
			$"hand-tilt".set_position(Vector2(orig_pos_x, pos.y))
			anim_time = 0	
	if index == 2:
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(center_x + (radius*cos(ang)), center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0
	if index == 4:
		$"hand-upside".set_position(Vector2(center_x, center_y))
		var anim_end = 1
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var scale =  0.5*per_cent
		if per_cent > 0.8:
			$"hand-click".show()
		else:
			$"hand-upside".set_scale(Vector2(1.5 - scale, 1.5 - scale))
		if anim_time > anim_end:
			$"hand-click".hide()
			anim_time = 0
	if index == 6:
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(center_x + (radius*cos(ang)), center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0


func _on_Skip_pressed():
	get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")


func _on_Next_pressed():
	index = index + 1
	_setSceneFromIndex()


func _on_Previsous_pressed():
	index = index - 1
	if index == -1:
		index = 0
	_setSceneFromIndex()

func _setSceneFromIndex():
	$"BGs/tutorial-1".hide()
	$"BGs/tutorial-2".hide()
	$"BGs/tutorial-3".hide()
	$"BGs/tutorial-4".hide()
	$BGs/PlayScene.hide()
	$"hand-tilt".hide()
	$"hand-stroke".hide()
	$"hand-upside".hide()
	$"hand-click".hide()
	$"btn-small-play".hide()
	_setPracticeMode("None")
	if index == 0:
		$"BGs/tutorial-1".show()
		$"hand-tilt".show()
		$"hand-stroke".show()
	if index == 1:
		_setPracticeMode("Shears")
	if index == 2:
		$"BGs/tutorial-2".show()
		$"hand-upside".show()
	if index == 3:
		_setPracticeMode("Watercan")
	if index == 4:
		$"BGs/tutorial-3".show()
		$"hand-upside".show()
		$"hand-click".show()
	if index == 5:
		_setPracticeMode("Fertilizer")
	if index == 6:
		$"hand-upside".show()
		$"hand-upside".set_scale(Vector2(1.0, 1.0))
		$"BGs/tutorial-4".show()
		$TextBack.show()
	if index == 7:
		_setPracticeMode("Bugspray")
	if index == 8:
		$Next.hide()
		$BGs/PlayScene.show()
		$TextBack.show()
		$"btn-small-play".show()
	if index == 9:
		get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")



func _setPracticeMode(mode):
	$PracticeTutorial.show()
	plant.get_node("Dried").modulate.a=0
	plant.get_node("Flowers").modulate.a=1
	plant.get_node("Bugs").modulate.a=0
	plant.get_node("Leaves").hide()
	workstation.get_node("Fertilizer").hide()
	workstation.get_node("Shears").hide()
	workstation.get_node("Watercan").hide()
	workstation.get_node("BugSpray").hide()
	workstation.disableEffects()
	plant.healthy_fertilizer = 0
	plant.healthy_branches = 0
	plant.healthy_water = 0
	plant.healthy_kills = 0
	plant.Fertilizer = 0
	plant.Branches = 0
	plant.Water = 0
	plant.Bugspray = 0
	$Next.hide()
	$TextBack.show()
	workstation.set_process_input(true)
	workstation.selectTool(-1)
	match mode:
		"Shears":
			$PracticeTutorial.show()
			for leafNode in plant.get_node("Leaves").get_children():
				leafNode.queue_free()
			for branch in backupPlantLeaves.get_children():
				plant.get_node("Leaves").add_child(branch.duplicate())
			plant.get_node("Leaves").show()
			workstation.get_node("Shears").show()
			plant.healthy_branches = 3
		"Watercan":
			$PracticeTutorial.show()
			plant.get_node("Dried").modulate.a=1
			workstation.get_node("Watercan").show()
			plant.healthy_water = 0.6
		"Bugspray":
			$PracticeTutorial.show()
			plant.get_node("Bugs").modulate.a=1
			workstation.get_node("BugSpray").show()
			plant.healthy_kills = 0.6
		"Fertilizer":
			$PracticeTutorial.show()
			plant.get_node("Flowers").modulate.a=0
			workstation.get_node("Fertilizer").show()
			plant.healthy_fertilizer = 5
		"None":
			workstation.set_process_input(false)
			plant.healthy_emmited = false
			$PracticeTutorial.hide()
			$Next.show()
			$TextBack.hide()

