extends WindowBase

@onready var GameResult = $Result

func _ready() -> void:
	hide()
	GameManager.game_state_changed.connect(update_info)

func update_info(stage) -> void:
	hide()
	
	match stage:
		GameManager.GameState.NOT_STARTED:
			pass
		
		GameManager.GameState.RUNNING:
			# 可以添加游戏运行时的逻辑，如果需要
			hide()
		
		GameManager.GameState.FINISHED:
			# 弹出窗口并显示结果
			popup()
			GameResult.show()

func _on_start_game_btn_pressed() -> void:
	hide_window()
	Utilities.switch_scene("MainMenu")
