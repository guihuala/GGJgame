extends Control

@onready var startPanel_1 = $StartPanel_1
@onready var startPanel_2 = $StartPanel_2

func _ready() -> void:
	show()

func _on_next_page_pressed() -> void:
	startPanel_1.hide()
	startPanel_2.show()

func _on_start_game_btn_2_pressed() -> void:
	GameManager.start_game()
	hide()
