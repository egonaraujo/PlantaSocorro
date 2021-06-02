extends Node

var _save_path = "user://score.txt"
var _score = 0

func GetActualScore() -> int:
	return _score

func AddActualScore(increment:int) -> void:
	_score = _score + increment

func NewActualScore(score:int) -> void:
	_score = score

func IsHighScoreAndSave() -> bool:
	var data = _load()
	if (_score > data):
		_save(_score)
		return true
	return false

func GetHighScore() -> int:
	return _load()

func _save(content:int) -> void:
	var file = File.new()
	file.open(_save_path, File.WRITE)
	file.store_32(content)
	file.close()

func _load() -> int:
	var file = File.new()
	file.open(_save_path, File.READ)
	var content = file.get_32()
	file.close()
	return content
