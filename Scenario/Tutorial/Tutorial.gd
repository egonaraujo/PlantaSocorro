extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var index = 0

var anim_time = 0

var orig_pos_x
var orig_pos_bar_y

var center_x = 400
var center_y = 278
var radius = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	orig_pos_x = $"hand-tilt".get_position().x
	orig_pos_bar_y = $"hand-stroke".get_position().y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_time = anim_time + delta
	if index == 0:
		var anim_end = 1
		var pos = $"hand-tilt".get_position()
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var offset =  119*per_cent
		$"hand-tilt".set_position(Vector2(orig_pos_x + offset, pos.y))
		$"hand-stroke".set_position(Vector2(orig_pos_x -15 + offset/2, orig_pos_bar_y))
		$"hand-stroke".set_scale(Vector2(per_cent, 1.0))
		if anim_time > anim_end:
			$"hand-tilt".set_position(Vector2(orig_pos_x, pos.y))
			anim_time = 0	
	if index == 1:
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(center_x + (radius*cos(ang)), center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0
	if index == 2:
		$"hand-upside".set_position(Vector2(center_x, center_y))
		var anim_end = 1
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var scale =  0.5*per_cent
		if per_cent > 0.8:
			$"hand-click".show()
		else:
			$"hand-upside".set_scale(Vector2(1.5 - scale, 1.5 - scale))
		if anim_time > anim_end:
			$"hand-click".hide()
			anim_time = 0
	if index == 3:
		var anim_end = 2
		var per_cent = 1-((anim_end - anim_time)/anim_end)
		var ang =  -6.28*per_cent
		$"hand-upside".set_position(Vector2(center_x + (radius*cos(ang)), center_y + (radius*sin(ang))))
		if anim_time > anim_end:
			anim_time = 0


func _on_Skip_pressed():
	get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")


func _on_Next_pressed():
	index = index + 1
	if index == 1:
		$"BGs/tutorial-1".hide()
		$"hand-tilt".hide()
		$"hand-stroke".hide()
		$"BGs/tutorial-2".show()
		$"hand-upside".show()
	if index == 2:
		$"BGs/tutorial-2".hide()
		$"BGs/tutorial-3".show()
		$"hand-click".show()
	if index == 3:
		$"hand-upside".set_scale(Vector2(1.0, 1.0))
		$"BGs/tutorial-3".hide()
		$"BGs/tutorial-4".show()
		$"btn-small-play".show()
		$"hand-click".hide()
	if index == 4:
		get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")
		
	pass # Replace with function body.
