extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer

# Music and sound dictionaries
var music_dict: Dictionary = {
	"BGM": preload("res://assets/audio/BGM/背景音乐.wav"),
	"BGM2":preload("res://assets/audio/BGM/背景音乐2.mp3")
}

var sound_dict: Dictionary = {
	"button_click": preload("res://assets/audio/Sfx/Modern10.wav"),
	"bubble":preload("res://assets/audio/Sfx/啵 弹出 冒泡.mp3"),
	"bubble2":preload("res://assets/audio/Sfx/弹出信息.mp3"),
	"succeed":preload("res://assets/audio/Sfx/成功！!__tada.wav"),
	"Buzz":preload("res://assets/audio/Sfx/手机震动声.mp3"),
	"tick":preload("res://assets/audio/Sfx/秒针滴滴答答 倒计时 .mp3"),
	"start":preload("res://assets/audio/Sfx/开机声音.mp3"),
	"end":preload("res://assets/audio/Sfx/电脑关机.mp3"),
	"Warn":preload("res://assets/audio/Sfx/warning-sound.mp3"),
	"long_press": preload("res://assets/audio/Sfx/长按音效.mp3")
}

func _ready():
	pass # Replace with function body.

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
