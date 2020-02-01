extends Node2D

signal plant_healthy

export (float) var increment = 1.0

var whichTool = -1;
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
#func _process(delta):
#	pass

func update_plant(plant, status_id):
	plant.update(status_id, increment)
	if plant.is_healthy():
		emit_signal("plant_healthy", plant.name)


func selectTool(var i):
	print("select tool %d"%i)

func tapPlant(plant_name):
	if(whichTool == 0):
		plant_name
	#update_plant(get_node(plant_name), 1)
	emit_signal("plant_healthy", plant_name)

	
