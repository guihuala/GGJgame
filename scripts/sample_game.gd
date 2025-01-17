extends Node2D

@onready var ui_layer: CanvasLayer = $CanvasLayer
@onready var settings: TabContainer = $CanvasLayer/Panel/Settings

'''
Flow chart
Game <==> Pause Menu ==> Settings
'''

func _ready():
	AudioManager.play_BGM("BGM")
	ui_layer.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("Escape"):
		if not ui_layer.visible:
			show_ui_layer()
		else:
			resume_game()

	if event is InputEventKey and event.keycode == KEY_SPACE and event.pressed:
		Dialogic.start('test')
		get_viewport().set_input_as_handled()

func show_ui_layer():
	pause_game()
	ui_layer.show()
	reset_focus()

func reset_focus():
	$CanvasLayer/Panel/PauseMenu/Resume.grab_focus()

func pause_game():
	Engine.time_scale = 0

func resume_game():
	Engine.time_scale = 1
	settings.hide()
	ui_layer.hide()

func _on_resume_pressed():
	resume_game()

func _on_option_pressed():
	settings.show()
	settings.reset_focus()

func _on_main_menu_pressed():
	Engine.time_scale = 1
	Utilities.switch_scene("MainMenu")

func _on_new_window_pressed() -> void:
	Utilities.DraggablePanel.create(
		"面板", 
		Vector2(400, 300), 
		Vector2(100, 100), 
		self
	)
