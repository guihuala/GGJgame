extends Node

# 广告类型场景数组
@export var ad_types: Array[PackedScene] = []

# 广告生成配置
var ad_generation_config = {
	GameManager.GamePhase.WORK: {
		"interval_min": 1.5,  # 最小间隔时间(小时)
		"interval_max": 2,  # 最大间隔时间(小时)
		"chance": 0.8,        # 生成概率
	},
	GameManager.GamePhase.OVERTIME: {
		"interval_min": 1.0,  # 最小间隔时间(小时)
		"interval_max": 2.5,  # 最大间隔时间(小时)
		"chance": 0.6,        # 生成概率 
	}
}

# 上次生成广告的游戏时间
var last_ad_game_time: float = 0.0

# 广告奖励范围
const BASE_REWARD = {
	GameManager.GamePhase.WORK: {"min": 10, "max": 30},
	GameManager.GamePhase.OVERTIME: {"min": 30, "max": 50}
}

# 屏幕尺寸引用
@onready var viewport_size: Vector2 = get_viewport().size

# 广告生成定时器
var ad_generation_timer: Timer

func _ready():
	# 监听游戏阶段变化
	GameManager.phase_changed.connect(_on_phase_changed)
	
	# 设置初始时间
	last_ad_game_time = GameManager.current_game_time
	
	# 创建并配置广告生成定时器
	ad_generation_timer = Timer.new()
	ad_generation_timer.one_shot = false  # 循环定时器
	ad_generation_timer.timeout.connect(_check_ad_generation)
	add_child(ad_generation_timer)
	
	# 初始启动定时器
	_start_ad_generation_timer()

# 根据当前游戏阶段启动定时器
func _start_ad_generation_timer():
	var current_phase = GameManager.current_phase
	
	# 只在工作和加班阶段生成广告
	if current_phase not in [GameManager.GamePhase.WORK, GameManager.GamePhase.OVERTIME]:
		ad_generation_timer.stop()
		return
	
	# 获取当前阶段的配置
	var config = ad_generation_config[current_phase]
	
	# 随机生成下一次广告的间隔时间
	var next_interval = randf_range(
		config["interval_min"], 
		config["interval_max"]
	)
	
	# 设置并启动定时器
	ad_generation_timer.wait_time = next_interval
	ad_generation_timer.start()

# 检查是否生成广告
func _check_ad_generation():
	var current_phase = GameManager.current_phase
	
	# 只在工作和加班阶段生成广告
	if current_phase not in [GameManager.GamePhase.WORK, GameManager.GamePhase.OVERTIME]:
		return
	
	var current_game_time = GameManager.current_game_time
	var config = ad_generation_config[current_phase]
	
	# 根据概率决定是否生成广告
	if randf() <= config["chance"]:
		generate_ad(current_phase)
		last_ad_game_time = current_game_time
	
	# 为下一次广告生成重新设置定时器
	_start_ad_generation_timer()

# 生成广告
func generate_ad(phase: GameManager.GamePhase):
	if ad_types.is_empty():
		print("没有可用的广告类型")
		return
	
	# 随机选择一个广告类型
	var ad_scene = ad_types[randi() % ad_types.size()]
	var ad_instance = ad_scene.instantiate()
	
	# 设置广告属性
	setup_ad_properties(ad_instance, phase)
	
	# 将广告添加到游戏主场景
	get_tree().root.add_child(ad_instance)
	
	# 连接信号
	ad_instance.ad_closed.connect(_on_ad_closed.bind(phase))
	ad_instance.reward_earned.connect(_on_reward_earned.bind(phase))

# 设置广告属性
func setup_ad_properties(ad: Node, phase: GameManager.GamePhase):
	# 根据游戏阶段设置不同的广告属性
	var reward_range = BASE_REWARD[phase]
	var base_reward = randi_range(reward_range["min"], reward_range["max"])
	
	# 在加班阶段，增加广告难度和奖励
	if phase == GameManager.GamePhase.OVERTIME:
		ad.max_close_attempts = 5  # 增加关闭尝试次数
		ad.duration = 4.0  # 减少广告显示时间
		base_reward = int(base_reward * 1.5)  # 增加奖励
	
	# 如果是 Control 类型，在屏幕内随机位置生成
	if ad is Control:
		# 计算可用的位置范围（预留一些边距）
		var margin_x = ad.size.x
		var margin_y = ad.size.y
		
		# 随机生成 x 和 y 坐标
		var random_x = randf_range(margin_x, viewport_size.x - margin_x)
		var random_y = randf_range(margin_y, viewport_size.y - margin_y)
		
		# 设置广告位置
		ad.position = Vector2(
			random_x - ad.size.x / 2, 
			random_y - ad.size.y / 2
		)
	
	# 设置广告奖励（可以通过属性或方法传递）
	if ad.has_method("set_reward"):
		ad.set_reward(base_reward)

# 游戏阶段变化时的处理
func _on_phase_changed(new_phase: GameManager.GamePhase):
	# 阶段改变时重新配置定时器
	_start_ad_generation_timer()

# 广告关闭事件处理
func _on_ad_closed(success: bool, phase: GameManager.GamePhase):
	if success:
		print("广告在%s阶段成功关闭" % phase)
	else:
		# 在加班阶段失败会扣除薪水
		if phase == GameManager.GamePhase.OVERTIME:
			var penalty = randi_range(5, 15)
			GameManager.decrease_salary(penalty)
			print("加班阶段广告失败，罚款：", penalty)

# 奖励处理
func _on_reward_earned(amount: int, phase: GameManager.GamePhase):
	# 根据不同阶段处理奖励
	if phase == GameManager.GamePhase.OVERTIME:
		# 加班期间双倍奖励
		amount *= 2
	
	GameManager.increase_salary(amount)
	print("获得奖励：", amount, " 在 ", phase, " 阶段")
