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

var current_bubble_count: int

func _ready() -> void:
	# 获取材质
	rect_mat = colorRect.material
	
	if rect_mat:
		# 确保材质是可编辑的
		rect_mat = rect_mat.duplicate()
		colorRect.material = rect_mat
	
	# 连接游戏阶段变化信号
	GameManager.phase_changed.connect(_on_phase_changed)

# 新增方法：处理阶段变化
func _on_phase_changed(phase):
	if phase == GameManager.GamePhase.SETTLEMENT:
		remove_all_children()

# 之前的方法保持不变
func _process(delta: float) -> void:
	on_check_()

func on_check_():
	# 检查当前子节点数量
	current_bubble_count = get_child_count()
	
	# 如果气泡数量超过最大限制
	if current_bubble_count >= max_bubble_count:
		GameManager.set_can_spawn_bubble(false)
	else:
		GameManager.set_can_spawn_bubble(true)
	
	chaos_value = current_bubble_count
	
	# 根据气泡数量动态调整时间流速
	var time_speed = calculate_time_speed(current_bubble_count)
	
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

func remove_all_children():
	# 遍历并标记所有子节点为待删除
	for child in get_children():
		child.queue_free()
