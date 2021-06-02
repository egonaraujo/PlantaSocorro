extends Control


func _ready():
	if( GameControllerSingleton.IsHighScoreAndSave()):
		print("yay highscore ", GameControllerSingleton.GetHighScore() )
