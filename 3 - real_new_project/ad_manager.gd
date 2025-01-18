extends Node

# 广告类型场景数组
@export var ad_types: Array[PackedScene] = []

# 广告生成概率
var phase_ad_chances = {
	GameManager.GamePhase.WORK: 0.4,     # 工作时间广告概率较高
	GameManager.GamePhase.OVERTIME: 0.6,  # 加班时间广告概率更高
}

# 广告间隔时间（游戏内时间）
var min_ad_interval_hours: float = 1.5  # 最小广告间隔1.5小时
var last_ad_game_time: float = 0.0

# 广告奖励范围
const BASE_REWARD = {
	GameManager.GamePhase.WORK: {"min": 10, "max": 30},
	GameManager.GamePhase.OVERTIME: {"min": 30, "max": 50}
}

# 屏幕尺寸引用
@onready var viewport_size: Vector2 = get_viewport().size

func _ready():
	# 监听游戏阶段变化
	GameManager.phase_changed.connect(_on_phase_changed)
		# 设置初始时间
	last_ad_game_time = GameManager.current_game_time
		
		# 启动广告检查定时器
	var timer = Timer.new()
	timer.wait_time = 3.0  # 每3秒检查一次是否需要显示广告
	timer.timeout.connect(_check_ad_generation)
	add_child(timer)
	timer.start()

func _check_ad_generation():
	if not GameManager:
		return
		
	var current_phase = GameManager.current_phase
	
	# 只在工作和加班阶段生成广告
	if current_phase not in [GameManager.GamePhase.WORK, GameManager.GamePhase.OVERTIME]:
		return
	
	var current_game_time = GameManager.current_game_time
	
	# 检查是否达到最小广告间隔
	if current_game_time - last_ad_game_time >= min_ad_interval_hours:
		var chance = phase_ad_chances.get(current_phase, 0.0)
		if randf() <= chance:
			generate_ad(current_phase)
			last_ad_game_time = current_game_time

func generate_ad(phase: GameManager.GamePhase):
	if ad_types.is_empty():
		print("No ad types available!")
		return
	
	# 随机选择一个广告类型
	var ad_scene = ad_types[randi() % ad_types.size()]
	var ad_instance = ad_scene.instantiate()
	
	# 设置广告属性
	setup_ad_properties(ad_instance, phase)
	
	# 将广告添加到游戏主场景
	get_tree().root.add_child(ad_instance)
	
	# 播放进入动画
	ad_instance.play_enter_animation()
	
	# 连接信号
	ad_instance.ad_closed.connect(_on_ad_closed.bind(phase))
	ad_instance.reward_earned.connect(_on_reward_earned.bind(phase))

func setup_ad_properties(ad: Node, phase: GameManager.GamePhase):
	# 根据游戏阶段设置不同的广告属性
	var reward_range = BASE_REWARD[phase]
	var base_reward = randi_range(reward_range["min"], reward_range["max"])
	
	# 在加班阶段，增加广告难度和奖励
	if phase == GameManager.GamePhase.OVERTIME:
		ad.max_close_attempts = 5  # 增加关闭尝试次数
		ad.duration = 4.0  # 减少广告显示时间
		base_reward = int(base_reward * 1.5)  # 增加奖励
	
	# 设置广告基本属性
	ad.title = "工作机会!" if phase == GameManager.GamePhase.WORK else "加班福利!"
	ad.description = "完成任务获得奖励" if phase == GameManager.GamePhase.WORK else "加班期间双倍奖励!"
	ad.reward = base_reward
	
	# 设置广告位置在屏幕中央
	if ad is Control:
		ad.position = (viewport_size - ad.size) / 2

func _on_phase_changed(new_phase: GameManager.GamePhase):
	# 阶段改变时重置广告时间
	if new_phase in [GameManager.GamePhase.WORK, GameManager.GamePhase.OVERTIME]:
		last_ad_game_time = GameManager.current_game_time

func _on_ad_closed(success: bool, phase: GameManager.GamePhase):
	if success:
		print("Ad closed successfully in phase: ", phase)
	else:
		# 在加班阶段失败会扣除薪水
		if phase == GameManager.GamePhase.OVERTIME:
			var penalty = randi_range(5, 15)
			GameManager.decrease_salary(penalty)
			print("Failed overtime ad, penalty: ", penalty)

func _on_reward_earned(amount: int, phase: GameManager.GamePhase):
	# 根据不同阶段处理奖励
	if phase == GameManager.GamePhase.OVERTIME:
		# 加班期间双倍奖励
		amount *= 2
	
	GameManager.increase_salary(amount)
	print("Reward earned: ", amount, " in phase: ", phase)

# 强制显示广告（可用于特殊事件）
func force_show_ad():
	generate_ad(GameManager.current_phase)
	last_ad_game_time = GameManager.current_game_time
