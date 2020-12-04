extends Node

var menu_music
var lose_music
var phase1_music
var phase2_music
var phase3_music
var phase4_music
var phase5_music

enum Music_Stream{ MAIN_MENU, PHASE1, PHASE2, PHASE3, PHASE4, PHASE5, LOSE,}
var next_stream
var current_stream
var has_next = false
var lowest_volume = -30
var target_volume = -5
export (float)var time_between_music = 0.5
var current_timer = 0
var fade_in = false

func _ready():
	menu_music = preload("res://MusicController/main_menu.ogg")
	lose_music = preload("res://MusicController/lose.ogg")
	phase1_music = preload("res://MusicController/phase_1.ogg")
	phase2_music = preload("res://MusicController/phase_2.ogg")
	phase3_music = preload("res://MusicController/phase_3.ogg")
	phase4_music = preload("res://MusicController/phase_4.ogg")
	phase5_music = preload("res://MusicController/phase_5.ogg")
	next_stream = menu_music
	current_stream = menu_music
	$MusicPlayer.volume_db=target_volume
	$MusicPlayer.stream = next_stream
	$MusicPlayer.play()
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	current_timer += delta
	var music_fade_percent = current_timer/time_between_music
	if has_next:
		if music_fade_percent > 1:
			$MusicPlayer.volume_db = lowest_volume
			$MusicPlayer.set_stream(next_stream)
			$MusicPlayer.play()
			has_next=false
			fade_in = true
			current_timer = 0
			current_stream = next_stream
		else:
			$MusicPlayer.volume_db = _value_from_percentage(music_fade_percent,
															target_volume,
															lowest_volume)
	if fade_in:
		if music_fade_percent > 1:
			music_fade_percent = 1
			fade_in = false
		$MusicPlayer.volume_db = _value_from_percentage(music_fade_percent,
															lowest_volume,
															target_volume)
	pass


func switchMusic(whichMusic, force = false):
	match whichMusic:
		Music_Stream.LOSE:
			next_stream = lose_music
		Music_Stream.PHASE1:
			next_stream = phase1_music
		Music_Stream.PHASE2:
			next_stream = phase2_music
		Music_Stream.PHASE3:
			next_stream = phase3_music
		Music_Stream.PHASE4:
			next_stream = phase4_music
		Music_Stream.PHASE5:
			next_stream = phase5_music
		Music_Stream.MAIN_MENU:
			next_stream = menu_music
		_:
			next_stream = menu_music
	if(current_stream == next_stream):
		return
	if (force):
		$MusicPlayer.set_stream(next_stream)
		$MusicPlayer.play()
		current_stream = next_stream
	else:
		has_next = true
		current_timer = 0
	pass


func changeVolume(newVolume):
	target_volume = newVolume
	if(!has_next):
		$MusicPlayer.volume_db = newVolume
	

func _value_from_percentage(percentage,minvalue,maxvalue):
	return (maxvalue-minvalue)*percentage + minvalue
