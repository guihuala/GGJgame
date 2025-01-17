extends Sprite2D

@export var squish_amount := 0.3  # 最大挤压程度
@export var squish_duration := 0.2  # 挤压动画持续时间
@export var restore_speed := 0.1  # 恢复速度

var current_bulge := 0.0
var target_bulge := 0.0
var is_squishing := false
var squish_timer := 0.0
var sprite_bounds: Rect2

func _ready():
	material = material as ShaderMaterial
	
	# 计算sprite的边界用于点击检测
	var texture_size = texture.get_size() * scale
	var sprite_pos = position - texture_size / 2
	sprite_bounds = Rect2(sprite_pos, texture_size)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if sprite_bounds.has_point(event.position):
				start_squish()

func _process(delta):
	if is_squishing:
		squish_timer += delta
		var progress = squish_timer / squish_duration
		
		if progress <= 0.5:
			current_bulge = lerp(0.0, -squish_amount, progress * 2)
		else:
			current_bulge = lerp(-squish_amount, squish_amount, (progress - 0.5) * 2)
		
		if squish_timer >= squish_duration:
			is_squishing = false
			squish_timer = 0.0
	else:
		# 不在挤压状态时，平滑恢复到原始状态
		current_bulge = lerp(current_bulge, 0.0, restore_speed)
		
		# 当变形很小时直接归零，避免微小抖动
		if abs(current_bulge) < 0.01:
			current_bulge = 0.0
	
	# 更新shader参数
	material.set_shader_parameter("bulge", current_bulge)

func start_squish():
	is_squishing = true
	squish_timer = 0.0
