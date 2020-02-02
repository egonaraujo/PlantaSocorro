extends Control

export (PackedScene)var next

var _tabs = []
var _buffer = []


var time_passed = 0;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal lose_phase
signal win_phase


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	for plant in $Workstation/Plants.get_children():
		_buffer.push_back("Workstation/Plants/%s" % plant.name)
		plant.disable()
	
	for i in range(0, 4):
		_tabs.push_back(_buffer[0])
		_buffer.pop_front()
	
	select_tab(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed = time_passed + delta
	if time_passed > 90: # one and a half minutes
		get_tree().change_scene("res://Scenario/Menu/Menu.tscn")
	
	var per_cent = 1-((90-time_passed)/90)
	var rotation = 90*per_cent
	$ClockArrow.rect_rotation = rotation


func select_tab(i):
	if _tabs[i] != "":
		for tab in _tabs:
			if tab != "":
				get_node(tab).disable()
		get_node(_tabs[i]).enable()
	print("Selecionei TAB: %d"%(i))
		# Ativa tab 

func _on_Tab4_pressed():
	#for tab in _tabs:
	#	get_node(tab).hide()
	#get_node(_tabs[0]).show()
	pass



func _on_Tab3_pressed():
	select_tab(3)



func _on_Tab2_pressed():
	select_tab(2)


func _on_Tab1_pressed():
	select_tab(1)


func _on_Tab0_pressed():
	select_tab(0)


func _on_Workstation_plant_healthy(plant_name):
	var index = 0

	for name in _tabs:
		if "Workstation/Plants/%s"% plant_name == name:
			break
		else:
			index = index +1
	$Workstation/Plants.remove_child(get_node(_tabs[index]))
	print(index)
	if _buffer.size() > 0:
		_tabs[index] = _buffer[0]
		_buffer.pop_front()
		get_node(_tabs[index]).enable()
		
	else:
		_tabs[index] = ""
	
	for name in _tabs:
		if ""!= name:
			return
	
	get_tree().change_scene_to(next)
	pass # Replace with function body.
