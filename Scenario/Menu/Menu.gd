extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.switchMusic(MusicController.Music_Stream.MAIN_MENU, true)
	MusicController.changeVolume(-5)
	pass # Replace with function body.


func _on_Play_pressed():
	get_tree().change_scene("res://Scenario/Tutorial/Tutorial.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenario/Credits/Credits.tscn")
