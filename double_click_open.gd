extends Control


@onready var window: Panel = $"../Window"

@export var double_click_time = 0.3 

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_double_click():
			open_app()

func open_app():
	window.show()
