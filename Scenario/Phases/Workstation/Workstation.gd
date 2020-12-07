extends Node2D

signal plant_healthy

export (AudioStreamOGGVorbis)var SlashSound
export (AudioStreamOGGVorbis)var SpraySound
export (AudioStreamOGGVorbis)var WaterSound
export (AudioStreamOGGVorbis)var FertilizerSound
export (float)var trailLength

var whichTool = -1
var isHolding = false
var isTouchingScreen = false
var slashedIndex = -1

#PlantScene
var ActivePlant

var trailRemoverTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	ActivePlant = null
	$Fertilizer.connect("tool_selected", self, "selectTool")
	$Shears.connect("tool_selected", self, "selectTool")
	$Watercan.connect("tool_selected", self, "selectTool")
	$BugSpray.connect("tool_selected", self, "selectTool")
	
	$Fertilizer.unselect()
	$Shears.unselect()
	$Watercan.unselect()
	$BugSpray.unselect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isHolding && ActivePlant != null 
	&& (whichTool ==2 || whichTool ==3)):
		update_plant(ActivePlant,whichTool, delta)
	trailRemoverTimer += delta
	if (trailRemoverTimer > 0.03
			&& $ShearsTrailLine2D.get_point_count() > 0):
		$ShearsTrailLine2D.remove_point(0)
		trailRemoverTimer = 0



func _input(event):
	#Animation of slashing
	if (event is InputEventScreenTouch):
		isTouchingScreen=event.is_pressed()
	if(whichTool == 1):
		if( event is InputEventScreenDrag):
			$ShearsTrailLine2D.add_point(event.position)
			if ($ShearsTrailLine2D.get_point_count() > trailLength):
				$ShearsTrailLine2D.remove_point(0)
				trailRemoverTimer = 0;

	if (event is InputEventScreenTouch):
		if(event.is_pressed()):
			var point = event.position
			var space_state = get_world_2d().direct_space_state
			var collidersTouched = space_state.intersect_point(point, 32, [],
					2147483647, false,true)
			var touchPlant = false
			for dict in collidersTouched:
				if (dict.collider == ActivePlant.get_node("Plant") ):
					touchPlant = true
					break
			if(touchPlant):
				tapPlant()
				holdPlant()
		if(!event.is_pressed() && isHolding):
			releasePlant()
	if( event is InputEventScreenDrag):
		var point = event.position
		var space_state = get_world_2d().direct_space_state
		var collidersTouched = space_state.intersect_point(
				point, 32, [],
				2147483647, false,true)
		var slashedPlant = false
		var stillOnPlant = false
		var slashedIndex = -1
		for dict in collidersTouched:
			if (dict.collider == ActivePlant.get_node("Leaves/Colliders")):
				slashedPlant = true
				slashedIndex = dict.shape
				break
			if (dict.collider == ActivePlant.get_node("Plant")):
				stillOnPlant = true
		if(!stillOnPlant && isHolding):
			releasePlant()
		elif(stillOnPlant && !isHolding):
			holdPlant()
		if(slashedPlant && event.speed.length() > 200):
			slashPlant(slashedIndex)


func update_plant(plant, status_id, increment):
	plant.update_status(status_id, increment)
	if plant.is_healthy() && !plant.healthy_emmited:
		plant.healthy_emmited = true;
		emit_signal("plant_healthy", plant.name)
		$AudioStreamPlayer.stop()
		isHolding = false


func selectTool(var i):
	whichTool=i;
	$Fertilizer.unselect()
	$Shears.unselect()
	$Watercan.unselect()
	$BugSpray.unselect()
	if whichTool == 0:
		$Fertilizer.select()
	elif whichTool == 1:
		$Shears.select()
	elif whichTool == 2:
		$Watercan.select()
	elif whichTool == 3:
		$BugSpray.select()
		


func tapPlant():
	if (whichTool == 0):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(FertilizerSound)
		$AudioStreamPlayer.play()
		update_plant(ActivePlant,whichTool,1)
			
func slashPlant(slashIndex):
	if(whichTool == 1):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SlashSound)
		$AudioStreamPlayer.play()
		update_plant(ActivePlant,whichTool,slashIndex)

func holdPlant():
	if(whichTool == 2 && !isHolding):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(WaterSound)
		$AudioStreamPlayer.play() 
		isHolding =true
	if(whichTool == 3 && !isHolding):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SpraySound)
		$AudioStreamPlayer.play()
		isHolding =true

func releasePlant():
	if((whichTool == 2 || whichTool == 3) && isHolding):
		$AudioStreamPlayer.stop()
		isHolding =false
