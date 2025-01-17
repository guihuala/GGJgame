extends Control

@export var window: Control

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_double_click():
			
			open_app()

func open_app():
	window.show()
