extends WindowBase

@onready var startPanel_1 = $StartPanel_1
@onready var startPanel_2 = $StartPanel_2
@onready var startPanel_3 = $StartPanel_3

func _ready() -> void:
	startPanel_1.show()
	startPanel_2.hide()
	startPanel_3.hide()

func _on_start_game_btn_2_pressed() -> void:
	GameManager.start_game()
	hide()
	
func _on_next_page_1_pressed() -> void:
	startPanel_1.hide()
	startPanel_2.show()

func _on_next_page_2_pressed() -> void:
	startPanel_2.hide()
	startPanel_3.show()
