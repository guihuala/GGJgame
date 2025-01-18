extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer

# Music and sound dictionaries
var music_dict: Dictionary = {
	"BGM": preload("res://assets/audio/BGM/背景音乐.wav"),
}

var sound_dict: Dictionary = {
	"button_click": preload("res://assets/audio/Sfx/Modern10.wav"),
	"bubble":preload("res://assets/audio/Sfx/啵 弹出 冒泡.mp3"),
	"succeed":preload("res://assets/audio/Sfx/成功！!__tada.wav"),
	"Buzz":preload("res://assets/audio/Sfx/手机震动声.mp3"),
	"tick":preload("res://assets/audio/Sfx/秒针滴滴答答 倒计时 .mp3"),
}

# Play a sound effect from the dictionary
func play_sfx(sound_key: String):
	if sound_key in sound_dict:
		sound_player.stream = sound_dict[sound_key]
		sound_player.play()
	else:
		printerr("Sound key not found in sound_dict: ", sound_key)

# Play music from the dictionary
func play_BGM(music_key: String):
	if music_key in music_dict:
		music_player.stream = music_dict[music_key]
		music_player.play()
	else:
		printerr("Music key not found in music_dict: ", music_key)
