extends Node2D

export (int)var toolID = -1;

signal tool_selected

func _input(event):
	if (event is InputEventScreenTouch):
		if(event.is_pressed()):
			var point = event.position
			var space_state = get_world_2d().direct_space_state
			var collidersTouched = space_state.intersect_point(point, 32, [],
													 2147483647, false,true)
			var touchItem = false
			for dict in collidersTouched:
				if (dict.collider == $Area2D):
					touchItem = true
					break
			if(touchItem):
				print("Tap Item")
				emit_signal("tool_selected",toolID)

func select():
	$highlight.show()

func unselect():
	$highlight.hide()

