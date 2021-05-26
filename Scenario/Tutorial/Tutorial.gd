extends Control

var index = 0

var anim_time = 0

var orig_pos_x
var orig_pos_bar_y

var anim_center_x = 1624
var anim_center_y = 1125
var radius = 100

var plant :Node2D
var backupPlantLeaves :Node2D
var workstation : Node2D
var plantTimer = 0
var plantHealthy = false
var orig_scale_up_hand
var target_scale
var target_tool
var isToolSelected

# Called when the node enters the scene tree for the first time.
func _ready():
	orig_pos_x = $"hand-tilt".get_position().x
	orig_pos_bar_y = $"hand-stroke".get_position().y
	orig_scale_up_hand = $"hand-upside".scale
	isToolSelected=false
	
	plant = $PracticeTutorial/Workstation/Plants/Cactus
	backupPlantLeaves = plant.get_node("Leaves").duplicate()
	workstation = $PracticeTutorial/Workstation
	workstation.connect("plant_healthy",self,"_plantHealthy")
	workstation.set_process_input(false)
	workstation.setActivePlant(plant)
	workstation.get_node("Shears").connect("tool_selected", self, "selectTool")
	workstation.get_node("Watercan").connect("tool_selected", self, "selectTool")
	workstation.get_node("BugSpray").connect("tool_selected", self, "selectTool")
	workstation.get_node("Fertilizer").connect("tool_selected", self, "selectTool")


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
		var offset =  440*per_cent
		$"hand-tilt".set_position(Vector2(orig_pos_x + offset, pos.y))
		$"hand-stroke".set_scale(Vector2(per_cent, 1.0))
		if anim_time > anim_end:
			$"hand-tilt".set_position(Vector2(orig_pos_x, pos.y))
			anim_time = 0
	if index == 1 && !isToolSelected:
		animTool("Shears")
	if index == 2:
		$"hand-upside".set_scale(orig_scale_up_hand)
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(anim_center_x + (radius*cos(ang)), anim_center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0
	if index == 3 && !isToolSelected:
		animTool("Watercan")
	if index == 4:
		$"hand-upside".set_position(Vector2(anim_center_x, anim_center_y))
		var anim_end = 1
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var scale =  per_cent
		if per_cent > 0.8:
			$"hand-click".show()
		else:
			$"hand-upside".set_scale(Vector2(1.8 - scale, 1.8 - scale))
		if anim_time > anim_end:
			$"hand-click".hide()
			anim_time = 0
	if index == 5 && !isToolSelected:
		animTool("Fertilizer")
	if index == 6:
		$"hand-upside".set_scale(orig_scale_up_hand)
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(anim_center_x + (radius*cos(ang)), anim_center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0
	if index == 7 && !isToolSelected:
		animTool("BugSpray")

func animTool(var whichTool):
	if anim_time>1:
		anim_time = 0
		workstation.get_node(whichTool).scale = target_scale
	if anim_time < 0.5:
		workstation.get_node(whichTool).scale = target_scale +(anim_time*0.3*target_scale)
	if anim_time > 0.5:
		workstation.get_node(whichTool).scale = 1.15*target_scale -((anim_time-0.5)*0.3*target_scale)


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
	if index%2==0:
		$TextSkip.add_color_override("default_color", Color("ff877b"))
		$ProximoText.add_color_override("default_color", Color("ff877b"))
		$TextBack.add_color_override("default_color", Color("ff877b"))
	else:
		$TextSkip.add_color_override("default_color", Color("305300"))
		$ProximoText.add_color_override("default_color", Color("305300"))
		$TextBack.add_color_override("default_color", Color("305300"))
	
	if index == 0:
		$"BGs/tutorial-1".show()
		$"hand-tilt".show()
		$"hand-stroke".show()
		$ProximoText.show()
	if index == 1:
		_setPracticeMode("Shears")
	if index == 2:
		$TextBack.show()
		$ProximoText.show()
		$"BGs/tutorial-2".show()
		$"hand-upside".show()
	if index == 3:
		_setPracticeMode("Watercan")
	if index == 4:
		$TextBack.show()
		$ProximoText.show()
		$"BGs/tutorial-3".show()
		$"hand-upside".show()
		$"hand-click".show()
	if index == 5:
		_setPracticeMode("Fertilizer")
	if index == 6:
		$TextBack.show()
		$ProximoText.show()
		$"hand-upside".show()
		$"BGs/tutorial-4".show()
		$TextBack.show()
	if index == 7:
		_setPracticeMode("BugSpray")
	if index == 8:
		$TextBack.show()
		$Next.hide()
		$BGs/PlayScene.show()
		$TextBack.show()
		$"btn-small-play".show()
	if index == 9:
		get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")



func _setPracticeMode(mode):
	$PracticeTutorial.show()
	plant.get_node("Dried").modulate.a=0
	plant.get_node("Flowers").hide()
	plant.get_node("Bugs").modulate.a=0
	plant.get_node("Leaves").hide()
	workstation.get_node("Fertilizer").hide()
	workstation.get_node("Shears").hide()
	workstation.get_node("Watercan").hide()
	workstation.get_node("BugSpray").hide()
	workstation.get_node("Fertilizer").required(true)
	workstation.get_node("Shears").required(true)
	workstation.get_node("Watercan").required(true)
	workstation.get_node("BugSpray").required(true)
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
	$ProximoText.hide()
	workstation.set_process_input(true)
	workstation.selectTool(-1)
	isToolSelected = false
	target_tool = mode
	match mode:
		"Shears":
			target_scale = workstation.get_node("Shears").scale
			$PracticeTutorial.show()
			for leafNode in plant.get_node("Leaves").get_children():
				leafNode.queue_free()
			for branch in backupPlantLeaves.get_children():
				plant.get_node("Leaves").add_child(branch.duplicate())
			plant.get_node("Leaves").show()
			workstation.get_node("Shears").show()
			plant.healthy_branches = 3
		"Watercan":
			target_scale = workstation.get_node("Watercan").scale
			$PracticeTutorial.show()
			plant.get_node("Dried").modulate.a=1
			workstation.get_node("Watercan").show()
			plant.healthy_water = 0.6
		"BugSpray":
			target_scale = workstation.get_node("BugSpray").scale
			$PracticeTutorial.show()
			plant.get_node("Bugs").modulate.a=1
			workstation.get_node("BugSpray").show()
			plant.healthy_kills = 0.6
		"Fertilizer":
			target_scale = workstation.get_node("Fertilizer").scale
			$PracticeTutorial.show()
			for flower in plant.get_node("Flowers").get_children():
				flower.resetAnim()
			plant.get_node("Flowers").show()
			workstation.get_node("Fertilizer").show()
			plant.healthy_fertilizer = 5
		"None":
			workstation.set_process_input(false)
			plant.healthy_emmited = false
			$PracticeTutorial.hide()
			$Next.show()
			$TextBack.hide()

func selectTool(var whichTool):
	isToolSelected=true
	workstation.get_node(target_tool).scale = target_scale

