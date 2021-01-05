extends Control

export (PackedScene)var next
export (int)var level

var _tabs = []
var _buffer = []
var _bar_check = []


var time_passed = 0;
var plants_done = 0;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	for plant in $Workstation/Plants.get_children():
		_buffer.push_back("Workstation/Plants/%s" % plant.name)
		plant.disable()
	for check in $Bar.get_children():
		_bar_check.push_front(check)
		check.undone()
	
	_tabs.push_back(_buffer[0])
	$Workstation.setActivePlant(get_node(_buffer.pop_front()))
	
	select_tab(0)
	
	var musicStream = MusicController.Music_Stream.PHASE1
	match level:
		1:
			musicStream = MusicController.Music_Stream.PHASE1
		2:
			musicStream = MusicController.Music_Stream.PHASE2
		3:
			musicStream = MusicController.Music_Stream.PHASE3
		4:
			musicStream = MusicController.Music_Stream.PHASE4
		5:
			musicStream = MusicController.Music_Stream.PHASE5
	MusicController.switchMusic(musicStream)
	MusicController.changeVolume(-13)
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

func _on_Workstation_plant_healthy(plant_name):
	var index = 0

	for name in _tabs:
		if "Workstation/Plants/%s"% plant_name == name:
			break
		else:
			index = index +1
	$Workstation/Plants.remove_child(get_node(_tabs[index]))
	_bar_check[plants_done].done()
	plants_done = plants_done +1
	if _buffer.size() > 0:
		_tabs[index] = _buffer[0]
		$Workstation.setActivePlant(get_node(_buffer.pop_front()))
		get_node(_tabs[index]).enable()
	else:
		_tabs[index] = ""
	for name in _tabs:
		if ""!= name:
			return
	$Workstation.disableEffects()
	get_tree().change_scene_to(next)
	pass # Replace with function body.
