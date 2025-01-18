extends Sprite2D

@export var rotation_speed := 0.1
@export var max_rotation := 1.0
@export var restore_speed := 0.1

var viewport_size: Vector2
var initial_mouse_pos: Vector2
var sprite_bounds: Rect2
var active_area: Rect2
var is_mouse_in_area := false  # 跟踪鼠标是否在区域内

func _ready():
	material = material as ShaderMaterial
	viewport_size = get_viewport().size
	
	# 计算sprite的边界
	var texture_size = texture.get_size() * scale
	var sprite_pos = position - texture_size / 2
	sprite_bounds = Rect2(sprite_pos, texture_size)
	
	# 计算实际的交互区域（考虑到sprite的位置和大小）
	var margin = texture_size * 0.1  # 添加10%的边距
	active_area = Rect2(
		sprite_bounds.position - margin,
		sprite_bounds.size + margin * 2
	)

func _process(_delta):
	# 如果鼠标不在区域内，逐渐恢复到原始状态
	if !is_mouse_in_area:
		var current_y_rot = material.get_shader_parameter("y_rot")
		var current_x_rot = material.get_shader_parameter("x_rot")
		
		# 使用lerp平滑过渡到0度（原始状态）
		var new_y_rot = lerp(current_y_rot, 0.0, restore_speed)
		var new_x_rot = lerp(current_x_rot, 0.0, restore_speed)
		
		# 当旋转值非常接近0时，直接设为0以避免微小抖动
		if abs(new_y_rot) < 0.01: new_y_rot = 0.0
		if abs(new_x_rot) < 0.01: new_x_rot = 0.0
		
		# 更新着色器参数
		material.set_shader_parameter("y_rot", new_y_rot)
		material.set_shader_parameter("x_rot", new_x_rot)

# 专门的输入事件处理方法
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		
		# 更新鼠标区域状态
		is_mouse_in_area = active_area.has_point(mouse_pos)
		
		# 如果鼠标不在活动区域内，直接返回
		if !is_mouse_in_area:
			return
		
		# 计算相对于sprite中心的偏移
		var sprite_center = sprite_bounds.get_center()
		var offset = mouse_pos - sprite_center
		
		# 将偏移标准化，使用sprite的尺寸而不是viewport
		var normalized_offset = Vector2(
			offset.x / (sprite_bounds.size.x / 2),
			offset.y / (sprite_bounds.size.y / 2)
		)
		
		# 限制normalized_offset在-1到1的范围内
		normalized_offset.x = clamp(normalized_offset.x, -1.0, 1.0)
		normalized_offset.y = clamp(normalized_offset.y, -1.0, 1.0)
		
		var y_rotation = normalized_offset.x * max_rotation
		var x_rotation = normalized_offset.y * max_rotation
		
		# 平滑过渡到新的旋转值
		var current_y_rot = material.get_shader_parameter("y_rot")
		var current_x_rot = material.get_shader_parameter("x_rot")
		
		var new_y_rot = lerp(current_y_rot, y_rotation, rotation_speed)
		var new_x_rot = lerp(current_x_rot, x_rotation, rotation_speed)
		
		# 更新着色器参数
		material.set_shader_parameter("y_rot", new_y_rot)
		material.set_shader_parameter("x_rot", new_x_rot)
