extends Node2D

export (int)var toolID = -1;
export (NodePath)var tool_asset

signal tool_selected

func _process(delta):
	$highlight.set_rotation($highlight.get_rotation() + delta)

func _input(event):
	if (self.visible == false):
		return
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
				emit_signal("tool_selected",toolID)

func select():
	$highlight.show()

func unselect():
	$highlight.hide()

func required(isRequired:bool):
	outline(isRequired)

func outline(show:bool):
	get_node(tool_asset).material.set_shader_param("outline_width", 2 if show  else 0)
