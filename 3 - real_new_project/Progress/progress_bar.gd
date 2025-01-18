extends ProgressBar

# 引用 GameManager
@onready var game_manager = get_node("/root/GameManager")

func _ready():
	# 连接游戏阶段变化信号
	game_manager.phase_changed.connect(_on_phase_changed)
	
	# 初始化进度条
	min_value = 0
	max_value = 100  # 百分比进度
	value = 100  # 从 100 开始
	
	# 设置进度条样式
	step = 0.1  # 精度
	rounded = true  # 圆角进度条

func _process(_delta):
	# 只在游戏运行状态下更新进度
	if game_manager.current_game_state == game_manager.GameState.RUNNING:
		# 更新进度条的值（倒计时）
		value = calculate_countdown_progress()

func calculate_countdown_progress() -> float:
	# 计算当天游戏时间比例（倒计时）
	var total_day_time = game_manager.DAY_END_TIME - game_manager.WORK_START_TIME
	var current_elapsed_time = game_manager.current_game_time - game_manager.WORK_START_TIME
	
	# 计算剩余时间的百分比（100 到 0）
	var remaining_progress = 100.0 * (1 - current_elapsed_time / total_day_time)
	
	# 确保进度在 0-100 范围内
	return clamp(remaining_progress, 0, 100)

func _on_phase_changed(new_phase):
	# 根据不同阶段可以调整进度条颜色或样式
	match new_phase:
		game_manager.GamePhase.PREPARE:
			# 准备阶段：灰色
			modulate = Color(0.5, 0.5, 0.5, 1)
		game_manager.GamePhase.WORK:
			# 工作阶段：从绿色渐变到红色
			modulate = Color(0, 1, 0, 1)
		game_manager.GamePhase.OVERTIME:
			# 加班阶段：黄色
			modulate = Color(1, 1, 0, 1)
		game_manager.GamePhase.SETTLEMENT:
			# 结算阶段：红色
			modulate = Color(1, 0, 0, 1)
