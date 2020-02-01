extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Skip_pressed():
	get_tree().change_scene("res://Scenario/Phases/Phase01/Phase01.tscn")


func _on_Next_pressed():
	pass # Replace with function body.
