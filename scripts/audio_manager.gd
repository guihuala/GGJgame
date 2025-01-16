extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer

# Music and sound dictionaries
var music_dict: Dictionary = {
	"BGM": preload("res://assets/audio/BGM/Ludum Dare 30 - 07.ogg"),
}

var sound_dict: Dictionary = {
	"button_click": preload("res://assets/audio/Sfx/Modern10.wav"),
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
