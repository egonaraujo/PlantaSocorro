extends Node

var _save_path = "user://gamedata.psc"
var _actual_game_data : GameData
var _saved_game_data : GameData

func _ready():
	_actual_game_data = GameData.new()
	_saved_game_data = GameData.new()
	_saved_game_data.read_from_file(_save_path)
	_actual_game_data.debug()
	_saved_game_data.debug()

func GetActualScoreLevel(level:int) -> int:
	_actual_game_data.debug()
	match (level):
		_: 
			return _actual_game_data.HighScore
		1: 
			return _actual_game_data.Level1Score
		2: 
			return _actual_game_data.Level2Score
		3: 
			return _actual_game_data.Level3Score
		4: 
			return _actual_game_data.Level4Score
		5: 
			return _actual_game_data.Level5Score


func GetHighScoreLevel(level:int) -> int:
	_saved_game_data.debug()
	match (level):
		_: 
			return _actual_game_data.HighScore
		1: 
			return _actual_game_data.Level1Score
		2: 
			return _actual_game_data.Level2Score
		3: 
			return _actual_game_data.Level3Score
		4: 
			return _actual_game_data.Level4Score
		5: 
			return _actual_game_data.Level5Score

func AddScoreForLevel(score:int, level:int):
	match (level):
		1: 
			_actual_game_data.Level1Score += score
			if (_actual_game_data.Level1Score > _saved_game_data.Level1Score):
				_saved_game_data.Level1Score = _actual_game_data.Level1Score
				_saved_game_data.write_to_file(_save_path)
		2: 
			_actual_game_data.Level2Score += score
			if (_actual_game_data.Level2Score > _saved_game_data.Level2Score):
				_saved_game_data.Level2Score = _actual_game_data.Level2Score
				_saved_game_data.write_to_file(_save_path)
		3: 
			_actual_game_data.Level3Score += score
			if (_actual_game_data.Level3Score > _saved_game_data.Level3Score):
				_saved_game_data.Level3Score = _actual_game_data.Level3Score
				_saved_game_data.write_to_file(_save_path)
		4: 
			_actual_game_data.Level4Score += score
			if (_actual_game_data.Level4Score > _saved_game_data.Level4Score):
				_saved_game_data.Level4Score = _actual_game_data.Level4Score
				_saved_game_data.write_to_file(_save_path)
		5: 
			_actual_game_data.Level5Score += score
			if (_actual_game_data.Level5Score > _saved_game_data.Level5Score):
				_saved_game_data.Level5Score = _actual_game_data.Level5Score
				_saved_game_data.write_to_file(_save_path)

func IsHighScoreAndSave() -> bool:
	_actual_game_data.HighScore = _actual_game_data.Level1Score
	_actual_game_data.HighScore += _actual_game_data.Level2Score
	_actual_game_data.HighScore += _actual_game_data.Level3Score
	_actual_game_data.HighScore += _actual_game_data.Level4Score
	_actual_game_data.HighScore += _actual_game_data.Level5Score
	_actual_game_data.debug()
	_saved_game_data.debug()
	if (_actual_game_data.HighScore > _saved_game_data.HighScore):
		_saved_game_data.HighScore = _actual_game_data.HighScore
		_saved_game_data.write_to_file(_save_path)
		return true
	return false

func ResetScores() -> void:
	_actual_game_data.reset()
