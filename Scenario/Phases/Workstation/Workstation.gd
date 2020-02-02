extends Node2D

signal plant_healthy

export (AudioStreamOGGVorbis)var SlashSound
export (AudioStreamOGGVorbis)var SpraySound
export (AudioStreamOGGVorbis)var WaterSound
export (AudioStreamOGGVorbis)var FertilizerSound

var whichTool = -1
var isHolding = 0
var whichPlant = null;
# Called when the node enters the scene tree for the first time.
func _ready():
	$Fertilizer.connect("tool_selected", self, "selectTool")
	$Shears.connect("tool_selected", self, "selectTool")
	$Watercan.connect("tool_selected", self, "selectTool")
	$BugSpray.connect("tool_selected", self, "selectTool")
	
	$Fertilizer.unselect()
	$Shears.unselect()
	$Watercan.unselect()
	$BugSpray.unselect()
	
	for c in $Plants.get_children():
		c.connect("plant_tapped",self,"tapPlant")
		c.connect("plant_slash",self,"slashPlant")
		c.connect("plant_hold_down",self,"holdPlant")
		c.connect("plant_hold_up",self,"releasePlant")
		#c.connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isHolding == 1 
	&& whichPlant != null 
	&& (whichTool ==2 || whichTool ==3)):
		update_plant(whichPlant,whichTool, delta)


func update_plant(plant, status_id, increment):
	plant.update_status(status_id, increment)
	if plant.is_healthy() && !plant.healthy_emmited:
		plant.healthy_emmited = true;
		emit_signal("plant_healthy", plant.name)
		$AudioStreamPlayer.stop()
		isHolding = 0


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
		


func tapPlant(plantNode):
	if (whichTool == 0):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(FertilizerSound)
		$AudioStreamPlayer.play()
		update_plant(plantNode,whichTool,1)
			
func slashPlant(plantNode):
	if(whichTool == 1):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SlashSound)
		$AudioStreamPlayer.play()
		update_plant(plantNode,whichTool,1)

func holdPlant(plantNode):
	if(whichTool == 2 && isHolding==0):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(WaterSound)
		$AudioStreamPlayer.play() 
		isHolding =1
		whichPlant = plantNode
	if(whichTool == 3 && isHolding==0):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.set_stream(SpraySound)
		$AudioStreamPlayer.play()
		isHolding =1
		whichPlant = plantNode

func releasePlant(plantNode):
	if(whichTool == 2 && isHolding==1):
		$AudioStreamPlayer.stop()
		isHolding =0
		whichPlant = null
	if(whichTool == 3 && isHolding==1):
		$AudioStreamPlayer.stop()
		isHolding =0
		whichPlant = null
		
