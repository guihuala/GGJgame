extends Control
# 广告数据
var close_attempts: int = 0
var max_close_attempts: int = 3
var reward: int = 0  # 购物广告的奖励/扣除金额
var duration: float = 5.0  # 广告持续时间
var current_phase: int  # 保存游戏阶段

# 信号
signal ad_closed(success: bool)
signal reward_earned(amount: int)

# 节点引用
@onready var CloseBtn = $CloseButton
@onready var close_areas: Control = $CloseArea1
@onready var timer: Timer = $Timer
@onready var label = $FloatingLabel
@onready var panel = $Panel

# 材质相关变量
var panel_mat: Material
var offset_value: float = 0.0

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	setup_ad()
	label.hide()
	
	# 获取材质
	panel_mat = panel.material
	if panel_mat:
		# 确保材质是可编辑的
		panel_mat = panel_mat.duplicate()
		panel.material = panel_mat

# 设置广告属性的方法，由广告生成器调用
func set_ad_properties(properties: Dictionary):
	# 从字典中设置广告属性
	if properties.has("max_close_attempts"):
		max_close_attempts = properties["max_close_attempts"]
	
	if properties.has("duration"):
		duration = properties["duration"]
	
	if properties.has("reward"):
		reward = properties["reward"]
	
	if properties.has("phase"):
		current_phase = properties["phase"]

func _process(delta: float):
	# 如果材质存在，持续更新偏移值
	if panel_mat:
		# 更新偏移值，使其循环
		offset_value += delta * 50.0  # 控制旋转速度
		offset_value = fmod(offset_value, 360.0)
		
		# 设置材质的 offset 属性
		panel_mat.set_shader_parameter("offset", offset_value)

func setup_ad():    
	# 随机设置关闭按钮位置
	randomize_close_buttons()
	
	# 启动计时器
	timer.wait_time = duration
	timer.start()

func randomize_close_buttons():
	pass

func _on_timer_timeout():
	# 广告展示时间结束，自动关闭
	ad_closed.emit(false)
	queue_free()

func _on_close_button_pressed():
	close_attempts += 1
	
	# 检查是否超过最大关闭尝试次数
	if close_attempts >= max_close_attempts:
		# 成功关闭广告
		ad_closed.emit(true)
		
		# 触发奖励
		if reward > 0:
			reward_earned.emit(reward)
		
		GameManager.unfocus_num += 1
		queue_free()
	else:
		label.show()
		label.text = "需要再点击 %d 次才能关闭广告" % (max_close_attempts - close_attempts)

# 可选：添加一个方法用于外部设置奖励
func set_reward(amount: int):
	reward = amount
