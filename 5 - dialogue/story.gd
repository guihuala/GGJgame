extends Control

func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.hide()
	$AnimationPlayer.play("fade_out")
