extends Control

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
	# Como ler as plantas de outra cena ???
	# Ler plantas, colocar nas tabs
	# Restante por no buffer
	
	#select_tab(i)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed = time_passed + delta
	if time_passed > 90000: # one and a half minutes
		emit_signal("lose_phase");
	
	var per_cent = (90000-time_passed)/90000
	var rotation = 90*per_cent
	get_node("ClockArrow").rect_rotation = rotation
	print(time_passed)

func select_tab(i):
	if _tabs[i] != "":
		for tab in _tabs:
			get_node(tab).hide()
		get_node(_tabs[i]).show()
		print_debug("Selecionei TAB: " + i)
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
