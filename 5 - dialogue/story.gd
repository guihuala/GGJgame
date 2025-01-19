extends Control

@onready var text_edit: TextEdit = $TextureRect/TextEdit  # 假设文本编辑器的节点名是 TextEdit
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var video_stream_player2: VideoStreamPlayer = $VideoStreamPlayer2
@onready var video_stream_player3: VideoStreamPlayer = $VideoStreamPlayer3

func _on_text_edit_gui_input(event: InputEvent) -> void:
	# 检查是否是键盘事件
	if event is InputEventKey:
		# 检查是否是回车键按下事件
		if event.pressed and event.keycode == KEY_ENTER:
			# 判定为编辑完成
			on_text_edit_text_set()


func on_text_edit_text_set() -> void:
	# 检查文本是否为空
	if not text_edit.text.is_empty():
		video_stream_player2.show()
		video_stream_player2.play()
		$TextureRect.hide()
		
func _on_video_stream_player_finished() -> void:
	video_stream_player.hide()

func _on_video_stream_player_2_finished() -> void:
	video_stream_player2.hide()
	video_stream_player3.show()
	video_stream_player3.play()

func _on_video_stream_player_3_finished() -> void:
	Utilities.switch_scene("GameScene")
