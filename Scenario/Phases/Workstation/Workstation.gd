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

var FertilizerParticleNodes

#PlantScene
var ActivePlant

var trailRemoverTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	FertilizerParticleNodes = []
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
	var particlesToRemove = []
	for fertilizerParticle in FertilizerParticleNodes:
		if(fertilizerParticle.time_alive > 2):
			particlesToRemove.append(fertilizerParticle)
	for particle in particlesToRemove:
		(FertilizerParticleNodes as Array).erase(particle)
		(particle as Particles2D).free()


func _input(event):
	#Animation of tools
	showToolAnimation(event)

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
			if (dict.collider == ActivePlant.get_node("Leaves").get_child(0)):
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
	if (whichTool == Tools.FERTILIZER):
		update_plant(ActivePlant,whichTool,1)
			
func slashPlant(slashIndex):
	if(whichTool == Tools.SHEARS):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SlashSound)
		$AudioStreamPlayer.play()
		update_plant(ActivePlant,whichTool,slashIndex)

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
