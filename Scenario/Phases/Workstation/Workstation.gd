extends Node2D

signal plant_healthy


var whichTool = -1
var isHolding = 0
var whichPlant = null;
# Called when the node enters the scene tree for the first time.
func _ready():
	$Tool0.connect("tool_selected", self, "selectTool")
	$Tool1.connect("tool_selected", self, "selectTool")
	$Tool2.connect("tool_selected", self, "selectTool")
	$Tool3.connect("tool_selected", self, "selectTool")
	
	for c in $Plants.get_children():
		c.connect("plant_tapped",self,"tapPlant")
		c.connect("plant_slash",self,"slashPlant")
		c.connect("plant_hold_down",self,"holdPlant")
		c.connect("plant_hold_up",self,"releasePlant")
		#c.connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isHolding == 1 && whichPlant != null):
		update_plant(whichPlant,whichTool, delta)

func update_plant(plant, status_id, increment):
	plant.update_status(status_id, increment)
	if plant.is_healthy() && !plant.healthy_emmited:
		plant.healthy_emmited = true;
		emit_signal("plant_healthy", plant.name)


func selectTool(var i):
	whichTool=i;

func tapPlant(plantNode):
	if(whichTool == 0):
		update_plant(plantNode,whichTool,1)
			
func slashPlant(plantNode):
	if(whichTool == 1):
		print("Slash")
		update_plant(plantNode,whichTool,1)

func holdPlant(plantNode):
	if(whichTool == 2 || whichTool == 3):
		isHolding =1
		whichPlant = plantNode

func releasePlant(plantNode):
	if(whichTool == 2 || whichTool == 3):
		isHolding =0
		whichPlant = null
