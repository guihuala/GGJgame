extends Node

# 最大气泡数量
@export var max_bubble_count: int = 16
@export var colorRect: ColorRect

# 材质相关变量
var rect_mat: Material
var chaos_value: float

# 时间流速相关常量
const MIN_TIME_SPEED: float = 1.0
const MAX_TIME_SPEED: float = 3.0

func _ready() -> void:
	# 获取材质
	rect_mat = colorRect.material
	
	if rect_mat:
		# 确保材质是可编辑的
		rect_mat = rect_mat.duplicate()
		colorRect.material = rect_mat

func _process(delta: float) -> void:
	on_check_()

func on_check_():
	# 检查当前子节点数量
	var current_bubble_count = get_child_count()
	
	# 如果气泡数量超过最大限制
	if current_bubble_count >= max_bubble_count:
		GameManager.set_can_spawn_bubble(false)
	else:
		GameManager.set_can_spawn_bubble(true)
	
	chaos_value = current_bubble_count
	
	# 根据气泡数量动态调整时间流速
	var time_speed = calculate_time_speed(current_bubble_count)
	GameManager.change_time_speed(time_speed)
	
	# 更新着色器参数
	if rect_mat:
		rect_mat.set_shader_parameter("chaos", chaos_value)

# 根据气泡数量计算时间流速
func calculate_time_speed(bubble_count: int) -> float:
	# 线性映射气泡数量到时间流速
	# 气泡数量越多，时间流速越快
	var normalized_count = float(bubble_count) / max_bubble_count
	
	# 使用线性插值计算时间流速
	# 从最小时间流速到最大时间流速
	var time_speed = lerp(MAX_TIME_SPEED - 1 ,MIN_TIME_SPEED, normalized_count)
	
	# 确保时间流速不低于最小值
	return max(time_speed, MIN_TIME_SPEED)

# 可选：清理超出数量的气泡
func clean_excess_bubbles():
	var bubbles = get_children()
	
	# 按添加顺序删除多余的气泡
	while get_child_count() > max_bubble_count:
		var oldest_bubble = bubbles.pop_front()
		if oldest_bubble:
			oldest_bubble.queue_free()
