extends Node2D

signal plant_healthy

export (AudioStreamOGGVorbis)var SlashSound
export (AudioStreamOGGVorbis)var SpraySound
export (AudioStreamOGGVorbis)var WaterSound
export (AudioStreamOGGVorbis)var FertilizerSound
export (float)var trailLength

enum Tools {NONE=-1, FERTILIZER=0, SHEARS, WATERCAN, BUGSPRAY,}
var whichTool = Tools.NONE
var isHolding = false
var slashedIndex = -1
var isSelectionTap = false

var FertilizerParticleNodes

#PlantScene
var _activePlant
var _oldPlant
var plantAnimState
var plantTimer

var trailRemoverTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	FertilizerParticleNodes = []
	_activePlant = null
	_oldPlant = null
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
	if plantAnimState != 0:
		plantTimer += delta
		animPlant()
		return
	if(isHolding && _activePlant != null 
	&& (whichTool ==2 || whichTool ==3)):
		update_plant(_activePlant,whichTool, delta)
	trailRemoverTimer += delta
	if (trailRemoverTimer > 0.03
			&& $ShearsTrailLine2D.get_point_count() > 0):
		$ShearsTrailLine2D.remove_point(0)
		trailRemoverTimer = 0
	var particlesToRemove = []
	for fertilizerParticle in FertilizerParticleNodes:
		if(fertilizerParticle.time_alive > 2):
			particlesToRemove.append(fertilizerParticle)
	for particle in particlesToRemove:
		(FertilizerParticleNodes as Array).erase(particle)
		(particle as Particles2D).free()


func _input(event):
	#Animation of tools
	if (event is InputEventScreenTouch):
		if(!event.is_pressed()):
			isSelectionTap = false
	
	if(isSelectionTap):
		return	
	showToolAnimation(event)

	if (event is InputEventScreenTouch):
		if(event.is_pressed()):
			var point = event.position
			var space_state = get_world_2d().direct_space_state
			var collidersTouched = space_state.intersect_point(point, 32, [],
					2147483647, false,true)
			var touchPlant = false
			for dict in collidersTouched:
				if (dict.collider == _activePlant.get_node("Plant") ):
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
			if (dict.collider == _activePlant.get_node("Leaves").get_child(0)):
				slashedPlant = true
				slashedIndex = dict.shape
				break
			if (dict.collider == _activePlant.get_node("Plant")):
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
		isHolding = false


func selectTool(var i):
	isSelectionTap = true
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
	if (whichTool == Tools.FERTILIZER):
		update_plant(_activePlant,whichTool,1)
			
func slashPlant(slashIndex):
	if(whichTool == Tools.SHEARS):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SlashSound)
		$AudioStreamPlayer.play()
		update_plant(_activePlant,whichTool,slashIndex)

func holdPlant():
	if(whichTool == Tools.WATERCAN && !isHolding):
		isHolding =true
	if(whichTool == Tools.BUGSPRAY && !isHolding):
		isHolding =true

func releasePlant():
	if((whichTool == Tools.WATERCAN || whichTool == Tools.BUGSPRAY) && isHolding):
		isHolding =false

func showToolAnimation(event):
	match whichTool:
		Tools.SHEARS:
			if( event is InputEventScreenDrag):
				$ShearsTrailLine2D.add_point(event.position)
				if ($ShearsTrailLine2D.get_point_count() > trailLength):
					$ShearsTrailLine2D.remove_point(0)
					trailRemoverTimer = 0;
		Tools.WATERCAN:
			updateEffectAndSound(event,$WaterParticles2D, WaterSound)
		Tools.BUGSPRAY:
			updateEffectAndSound(event,$BugSprayParticles2D, SpraySound)
		Tools.FERTILIZER:
			if( event is InputEventScreenTouch):
				if(event.is_pressed()):
					var newFertilizer = $FertilizerSprayParticles2D.duplicate()
					add_child(newFertilizer)
					newFertilizer.position = event.position
					newFertilizer.emitting = event.is_pressed()
					FertilizerParticleNodes.append(newFertilizer)
					$AudioStreamPlayer.stop()
					$AudioStreamPlayer.set_stream(FertilizerSound)
					$AudioStreamPlayer.play()

func updateEffectAndSound(event, particles : Particles2D ,sound):
	if( event is InputEventScreenDrag):
		if(particles != null):
			particles.position = event.position
	if( event is InputEventScreenTouch):
		if(particles != null):
			particles.emitting = event.is_pressed()
			particles.position = event.position
		if (event.is_pressed()):
			$AudioStreamPlayer.stop()
			$AudioStreamPlayer.set_stream(sound)
			$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.stop()

func disableEffects():
	$AudioStreamPlayer.stop()
	$BugSprayParticles2D.emitting = false
	$WaterParticles2D.emitting = false

func setActivePlant(plant:Node2D):
	_oldPlant = _activePlant
	_activePlant = plant
	plantAnimState = 1 if _oldPlant != null else 2
	plantTimer = 0
	_activePlant.connect("plant_watered", self, "plant_watered")
	_activePlant.connect("plant_slashed", self, "plant_slashed")
	_activePlant.connect("plant_flowered", self, "plant_flowered")
	_activePlant.connect("plant_sprayed", self, "plant_sprayed")
	$Fertilizer.required(true)
	$BugSpray.required(true)
	$Shears.required(true)
	$Watercan.required(true)

func animPlant():
	# states: 1- leaving old 2- entering new
	# plantTimer is percent, between 0 and 1
	var finalPos
	var finalScale
	var finalPlant
	var percent = _easeInOut(plantTimer)

	if plantAnimState == 1:
		finalPos =_oldPlant.orig_position
		finalScale = _oldPlant.orig_scale
		finalPlant = _oldPlant
	if plantAnimState == 2:
		finalPos = _activePlant.active_position
		finalScale = _activePlant.active_scale
		finalPlant = _activePlant
		percent = 1-percent # direction of motion swapped

	_setPlantPositionPercent(finalPlant, percent, finalPlant.active_position,
		finalPlant.orig_position)
	_setPlantScalePercent(finalPlant, percent, finalPlant.active_scale,
		finalPlant.orig_scale)

	if plantTimer > 1:
		finalPlant.position =finalPos
		finalPlant.scale = finalScale
		plantTimer =0
		plantAnimState+=1
		if plantAnimState > 2:
			plantAnimState =0

func _easeInOut(var percent:float) -> float:
	if (percent < 0.5):
		return 4 * pow(percent, 3)
	else:
		return 1 - pow(-2 * percent + 2, 3) / 2

func _setPlantPositionPercent(var plant:Node2D, var percent, var start, var end):
	plant.position = start + (percent*(end-start))

func _setPlantScalePercent(var plant:Node2D, var percent, var start, var end):
	plant.scale = start + (percent*(end-start))

func plant_watered():
	$Watercan.required(false)
func plant_slashed():
	$Shears.required(false)
func plant_flowered():
	$Fertilizer.required(false)
func plant_sprayed():
	$BugSpray.required(false)
