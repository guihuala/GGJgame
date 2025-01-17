extends Button

@onready var control: Control = $".."

func _ready() -> void:
	pressed.connect(control.window_vibrate)
