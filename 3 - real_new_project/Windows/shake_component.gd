extends Camera2D

@export var target: Node

#var should_drag: bool = false
#var offset: Vector2
#
#@export var time: float = 15
@export var shake_intensity: float = 0
@export var threshold: int
#@export var shake_time: float
#@export_group("1")
#@export var time_1: float = 8
#@export var shake_intensity_1: float = 2
#@export_group("2")
#@export var time_2: float = 5
#@export var shake_intensity_2: float = 4
#@export_group("3")
#@export var time_3: float = 3
#@export var shake_intensity_3: float = 6

func _ready() -> void:
	#hide()
	pass

func _physics_process(delta: float) -> void:
	#time -= delta
	if target.current_bubble_count >= threshold:
		offset = Vector2(
			randf_range(- shake_intensity,  + shake_intensity),
			randf_range(- shake_intensity,  + shake_intensity)
		)
	else:
		offset = Vector2(0,0)
	#if time < time_1:
		#shake_intensity = shake_intensity_1
	#if time < time_2:
		#shake_intensity = shake_intensity_2
	#if time < time_3:
		#shake_intensity = shake_intensity_3
	#if time < 0:
		#queue_free()
		#后续处理
	
	
#func _process(_delta: float) -> void:
	#if should_drag:
		#global_position = get_global_mouse_position() - offset
	#
#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.is_pressed():
				#should_drag = true
				#offset = get_global_mouse_position() - global_position
			#else:
				#should_drag = false
