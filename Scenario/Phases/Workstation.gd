extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tool0.connect("tool_selected", self, "selectTool")
	$Tool1.connect("tool_selected", self, "selectTool")
	$Tool2.connect("tool_selected", self, "selectTool")
	$Tool3.connect("tool_selected", self, "selectTool")
	
	for c in $Plants.get_children():
		pass
		#c.connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func selectTool(var i):
	pass
