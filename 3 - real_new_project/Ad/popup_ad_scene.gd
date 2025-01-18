extends Control

# 广告数据
var close_attempts: int = 0
var max_close_attempts: int = 3
var reward: int = 0  # 购物广告的奖励/扣除金额
var duration: float = 5.0  # 广告持续时间

# 信号
signal ad_closed(success: bool)
signal reward_earned(amount: int)

# 节点引用
@onready var close_areas: Array[Control] = [
	$CloseArea1, 
	$CloseArea2, 
	$CloseArea3
]
@onready var timer: Timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	setup_ad()

func setup_ad():    
	# 随机设置关闭按钮位置
	randomize_close_buttons()
	
	# 启动计时器
	timer.wait_time = duration
	timer.start()

func randomize_close_buttons():
	# 随机隐藏部分关闭区域
	for area in close_areas:
		area.visible = randf() > 0.5
	
	# 确保至少有一个关闭区域可见
	if not close_areas.any(func(area): return area.visible):
		close_areas[randi() % close_areas.size()].visible = true
	
	# 随机设置位置
	for area in close_areas:
		if area.visible:
			# 获取父容器的大小
			var parent_size = get_parent().size
			# 设置随机位置，确保不超出边界
			var x = randf_range(0, parent_size.x - area.size.x)
			var y = randf_range(0, parent_size.y - area.size.y)
			area.position = Vector2(x, y)

func _on_timer_timeout():
	# 广告展示时间结束，自动关闭
	ad_closed.emit(false)
	queue_free()

func _on_button_pressed() -> void:
	ad_closed.emit(true)
	queue_free()
