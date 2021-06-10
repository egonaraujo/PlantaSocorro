extends Control

export var level:int
var personal_best
var actual_score

func _ready():
	actual_score = GameControllerSingleton.GetActualScoreLevel(level)
	personal_best = GameControllerSingleton.GetHighScoreLevel(level)
	
	if (level == 5):
		var actual_high_score = GameControllerSingleton.GetActualScoreLevel(0)
		var highest_score = GameControllerSingleton.GetHighScoreLevel(0)
