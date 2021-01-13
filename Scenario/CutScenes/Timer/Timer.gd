extends Node2D

export (PackedScene) var next
export (float) var delay = 4

var delayed_time = 0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delayed_time = delayed_time + delta
	if delayed_time > delay:
		get_tree().change_scene_to(next)
	
	var per_cent = 1-((delay-delayed_time)/delay)
	var transform = -1246*per_cent

	$BG01.set_position(Vector2(0, transform))
	$BG04.set_position(Vector2(0, transform))
	$BG02.set_position(Vector2(0, transform))
