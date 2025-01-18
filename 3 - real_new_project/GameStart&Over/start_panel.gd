extends WindowBase

@onready var GameTitle = $title
@onready var GameResult = $Result

func _ready() -> void:
	GameResult.hide()
	GameManager.game_state_changed.connect(update_info)

func update_info(stage) -> void:
	GameResult.hide()
	GameTitle.hide()
	
	match stage:
		GameManager.GameState.NOT_STARTED:
			GameTitle.show()
			
		GameManager.GameState.NOT_STARTED:
			pass
			
		GameManager.GameState.FINISHED:
			self.show()
			GameResult.show()

func _on_game_over() -> void:
	self.show

func _on_start_game_btn_pressed() -> void:
	self.hide()
	GameManager.start_game()
