extends TabContainer

@export var pre_scene: Node

@onready var audio: TabBar = $Audio

func _ready():
	reload_settings()

func reset_focus():
	if current_tab == 0: # Audio
		$Audio.grab_focus()


func reload_settings():
	audio.load_audio_settings()

func _on_back_pressed():
	pre_scene.reset_focus()
