extends Control

func _ready() -> void:
	$VideoStreamPlayer.connect("finished", on_video_stream_player_finished)

func _input(event: InputEvent) -> void:
	# 检查是否按下 ESC 键
	if event.is_action_pressed("ui_cancel"):  # ui_cancel 是 ESC 键的默认映射
		on_video_stream_player_finished()

func on_video_stream_player_finished() -> void:
	Utilities.switch_scene("MainMenu")
