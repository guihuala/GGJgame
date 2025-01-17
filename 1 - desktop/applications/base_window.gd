extends Control

var should_drag: bool = false
var offset: Vector2

@export var time: float = 15
@export var shake_intensity: float = 0
@export_group("1")
@export var time_1: float = 8
@export var shake_intensity_1: float = 2
@export_group("2")
@export var time_2: float = 5
@export var shake_intensity_2: float = 4
@export_group("3")
@export var time_3: float = 3
@export var shake_intensity_3: float = 6




func _ready() -> void:
	hide()

func _on_button_pressed() -> void:
	hide()


func _physics_process(delta: float) -> void:
	time -= delta
	global_position = Vector2(
		randf_range(global_position.x - shake_intensity, global_position.x + shake_intensity),
		randf_range(global_position.y - shake_intensity, global_position.y + shake_intensity)
	)
	if time < time_1:
		shake_intensity = shake_intensity_1
	if time < time_2:
		shake_intensity = shake_intensity_2
	if time < time_3:
		shake_intensity = shake_intensity_3
	if time < 0:
		queue_free()
		#后续处理
	
	
func _process(_delta: float) -> void:
	if should_drag:
		global_position = get_global_mouse_position() - offset
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				should_drag = true
				offset = get_global_mouse_position() - global_position
			else:
				should_drag = false
