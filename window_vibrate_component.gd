extends Control

@export_group("Window_Vibrate")
@export var vibrate_intensity: float = 2.0
@export var vibrate_duration: float = 0.2

var should_vibrate: bool = false

func window_vibrate():
	should_vibrate = true
	await get_tree().create_timer(vibrate_duration).timeout
	should_vibrate = false
	
func _physics_process(delta: float) -> void:
	if should_vibrate:
		size = Vector2(
			randf_range(size.x - vibrate_intensity, size.x + vibrate_intensity),
			randf_range(size.y - vibrate_intensity, size.y + vibrate_intensity)
		)
	else:
		size = Vector2(2560,1440)
		
