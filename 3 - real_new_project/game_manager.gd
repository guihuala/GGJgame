extends Node

# 游戏状态枚举
enum GameState {
	NOT_STARTED,  # 游戏未开始
	RUNNING,      # 游戏进行中
	FINISHED      # 游戏已结束
}

# 薪水
var current_salary: int = 0
# 当前游戏状态
var current_game_state: GameState = GameState.NOT_STARTED

enum DailyGrade {
	A,
	B,
	C,
	D,
	E
}
# 分别统计每天的游戏数据
var daily_salary:int
var daily_grade: DailyGrade #每日绩效 根据专注度推出
var daily_focus # 专注度 根据处理的有效信息和点击到的无效信息计算

var solved_bubble_num:int # 每日处理的有效信息
var unfocus_num:int # 点到了广告或者垃圾邮件

# 通知UI更新的信号
signal salary_changed(salary:int,amount: int)
signal salary_decrease
signal game_state_changed(state: GameState)
signal phase_changed(phase: GamePhase)
signal day_started(day: int)
signal day_ended(day: int)

enum GamePhase {
	PREPARE,    # 准备阶段
	WORK,       # 正常工作阶段 (9:30-18:30)
	OVERTIME,   # 加班阶段 (18:30-21:30)
	SETTLEMENT  # 结算阶段
}

# 常量
const WORK_START_TIME = 9.5  # 9:30
const WORK_END_TIME = 18.5   # 18:30
const DAY_END_TIME = 20.5    # 20:30
const DAY_DURATION = 180.0   # 3分钟实际时间
const TOTAL_DAYS = 5         # 总天数

# 状态变量
var current_phase: GamePhase = GamePhase.PREPARE
var current_day: int = 1
var current_game_time: float = WORK_START_TIME
var timer: Timer
var can_spawn_bubble: bool = true

# 视频播放计时器
var video_timer: Timer
var VideoPlayer

# 时间流速相关常量
const DEFAULT_TIME_SPEED = 1.0  # 默认时间流速
const MAX_TIME_SPEED = 3.0      # 最大时间流速
const MIN_TIME_SPEED = 0.5      # 最小时间流速

# 时间流速变量
var current_time_speed: float = DEFAULT_TIME_SPEED

# 每日新闻
var random_index = 0

# 每日统计数据结构
class DailyStatistics:
	var day: int
	var salary: int
	var grade: DailyGrade
	var focus: float
	var solved_bubble_num: int
	var unfocus_num: int
	
	func _init(p_day: int):
		day = p_day
		salary = 0
		grade = DailyGrade.E
		focus = 0.0
		solved_bubble_num = 0
		unfocus_num = 0

# 存储每日统计数据的数组
var daily_statistics: Array[DailyStatistics] = []

# 重置每日统计数据
func reset_daily_statistics():
	daily_statistics.clear()
	# 为每一天创建统计对象
	for i in range(1, TOTAL_DAYS + 1):
		daily_statistics.append(DailyStatistics.new(i))

func update_daily_statistics():
	if current_day < 1 or current_day > TOTAL_DAYS:
		print("无效的天数")
		return
	
	# 获取当前天的统计对象
	var daily_stat = daily_statistics[current_day - 1]
	
	# 修改薪水计算逻辑
	if current_day == 1:
		# 第一天直接使用当前薪水
		daily_stat.salary = current_salary
	else:
		# 后续天数计算与前一天的差值
		daily_stat.salary = current_salary - daily_statistics[current_day - 2].salary

	# 其他代码保持不变
	daily_stat.solved_bubble_num = solved_bubble_num
	daily_stat.unfocus_num = unfocus_num
	
	var total_bubbles = solved_bubble_num + unfocus_num
	daily_stat.focus = 0.0 if total_bubbles == 0 else float(solved_bubble_num) / total_bubbles
	
	# 传入工资和专注度计算绩效等级
	daily_stat.grade = calculate_daily_grade(daily_stat.focus, daily_stat.salary)
	
	random_index = randi_range(0,3)
	
# 根据专注度和工资计算每日等级
func calculate_daily_grade(focus: float, salary: int) -> DailyGrade:
	# 定义工资和专注度的权重
	var focus_weight = 0.6  # 专注度权重
	var salary_weight = 0.4  # 工资权重
	
	# 定义每个等级的工资和专注度阈值
	var grade_thresholds = {
		"A": {"focus": 0.9, "salary": 300},
		"B": {"focus": 0.7, "salary": 200},
		"C": {"focus": 0.5, "salary": 150},
		"D": {"focus": 0.3, "salary": 100},
		"E": {"focus": 0.0, "salary": 0}
	}
	
	# 计算归一化的专注度和工资分数
	var normalized_focus = clamp(focus, 0.0, 1.0)
	var max_expected_salary = 500.0  # 设置一个合理的最大期望薪水
	var normalized_salary = clamp(salary / max_expected_salary, 0.0, 1.0)
	
	# 计算综合得分
	var combined_score = (normalized_focus * focus_weight) + (normalized_salary * salary_weight)
	
	# 根据综合得分确定等级
	if combined_score >= 0.9:
		return DailyGrade.A
	elif combined_score >= 0.7:
		return DailyGrade.B
	elif combined_score >= 0.5:
		return DailyGrade.C
	elif combined_score >= 0.3:
		return DailyGrade.D
	else:
		return DailyGrade.E

# 获取特定天的统计数据
func get_daily_statistics(day: int) -> DailyStatistics:
	if day < 1 or day > TOTAL_DAYS:
		print("无效的天数")
		return null
	return daily_statistics[day - 1]

# 获取所有每日统计数据
func get_all_daily_statistics() -> Array[DailyStatistics]:
	return daily_statistics

func start_game():
	# 重置每日统计数据
	reset_daily_statistics()
	
	current_day = 1
	current_game_time = WORK_START_TIME
	current_phase = GamePhase.PREPARE
	
	# 重置时间流速到默认值
	current_time_speed = DEFAULT_TIME_SPEED
	
	# 重置每日数据
	daily_salary = 0
	solved_bubble_num = 0
	unfocus_num = 0
	
	# 设置初始薪水
	set_salary(0)
	
	# 设置游戏状态为进行中
	change_game_state(GameState.RUNNING)
	
	# 设置计时器
	setup_timer()
	
	# 开始第一天
	start_day()
	
	VideoPlayer = get_tree().get_nodes_in_group("Video")[0]

func end_day():
	# 更新当前天的统计数据
	update_daily_statistics()
	
	# 停止计时器
	if timer:
		timer.stop()
	
	# 设置阶段为结算阶段
	current_phase = GamePhase.SETTLEMENT
	emit_signal("phase_changed", current_phase)
	emit_signal("day_ended", current_day)
	
	# 重置时间流速
	reset_time_speed()

# 新增方法：开始下一天
func start_next_day():
	# 只有在结算阶段才能开始下一天
	if current_phase != GamePhase.SETTLEMENT:
		print("只能在结算阶段开始下一天")
		return
	
	# 进入下一天或结束游戏
	current_day += 1
	if current_day <= TOTAL_DAYS:
		current_game_time = WORK_START_TIME
		start_day()
	else:
		# 达到总天数，结束游戏
		end_game()

func end_game():
	# 停止计时器
	if timer:
		timer.stop()
	
	# 设置游戏状态为已结束
	change_game_state(GameState.FINISHED)
	

# 改变时间流速的方法
func change_time_speed(speed: float) -> bool:
	# 检查速度是否在允许的范围内
	if speed < MIN_TIME_SPEED or speed > MAX_TIME_SPEED:
		return false

	current_time_speed = speed
	
	# 如果计时器存在，调整其等待时间
	if timer:
		# 根据时间流速调整计时器的间隔
		timer.wait_time = 1.0 / current_time_speed
	
	return true

# 重置时间流速到默认值
func reset_time_speed():
	change_time_speed(DEFAULT_TIME_SPEED)

# 获取当前时间流速
func get_time_speed() -> float:
	return current_time_speed

# 修改 setup_timer 方法以支持时间流速
func setup_timer():
	# 如果计时器已存在，先移除
	if timer:
		timer.queue_free()
	
	# 创建新的计时器
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# 根据当前时间流速设置计时器间隔
	var real_time_step = 1.0 / current_time_speed
	timer.wait_time = real_time_step
	
	# 添加时间流速变化的逻辑到 _on_timer_timeout
	timer.timeout.connect(func():
		# 原有的时间更新逻辑
		if current_game_state != GameState.RUNNING:
			return
		
		# 更新游戏时间，考虑时间流速
		var time_step = (DAY_END_TIME - WORK_START_TIME) / DAY_DURATION * current_time_speed
		current_game_time += time_step
		
		# 检查并更新阶段
		if current_game_time >= DAY_END_TIME:
			end_day()
		elif current_game_time >= WORK_END_TIME and current_phase == GamePhase.WORK:
			current_phase = GamePhase.OVERTIME
			emit_signal("phase_changed", current_phase)
	)

func set_can_spawn_bubble(value:bool) -> void:
	can_spawn_bubble = value

func get_can_spawn_bubble() -> bool:
	return can_spawn_bubble

# 改变游戏状态的方法
func change_game_state(new_state: GameState):
	current_game_state = new_state
	emit_signal("game_state_changed", current_game_state)


func start_day():
	# 只有在游戏运行中才能开始新的一天
	if current_game_state != GameState.RUNNING:
		return
	
	current_phase = GamePhase.PREPARE
	emit_signal("phase_changed", current_phase)
	emit_signal("day_started", current_day)
	
	# 延迟一段时间后开始工作阶段
	await get_tree().create_timer(3.0).timeout
	
	# 再次检查游戏状态
	if current_game_state != GameState.RUNNING:
		return
	
	current_phase = GamePhase.WORK
	emit_signal("phase_changed", current_phase)
	
	# 只有在游戏运行中才启动计时器
	if current_game_state == GameState.RUNNING:
		timer.start()

func _on_timer_timeout():
	# 只在游戏运行中更新时间
	if current_game_state != GameState.RUNNING:
		return
	
	# 更新游戏时间
	var time_step = (DAY_END_TIME - WORK_START_TIME) / DAY_DURATION
	current_game_time += time_step
	
	# 检查并更新阶段
	if current_game_time >= DAY_END_TIME:
		end_day()
	elif current_game_time >= WORK_END_TIME and current_phase == GamePhase.WORK:
		current_phase = GamePhase.OVERTIME
		emit_signal("phase_changed", current_phase)


func increase_salary(amount: int):
	current_salary += amount
	emit_signal("salary_changed", current_salary,amount)

func decrease_salary(amount: int):
	current_salary -= amount
	if current_salary < 0:
		current_salary = 0
	emit_signal("salary_changed", current_salary,-amount)
	emit_signal("salary_decrease")

func get_salary() -> int:
	return current_salary

func set_salary(amount: int):
	current_salary = amount
	emit_signal("salary_changed", current_salary, amount)

func _on_play_video():
	var character = get_tree().get_nodes_in_group("Character")[0]
	character.play_animation_angry()
	
	# 创建视频计时器
	video_timer = Timer.new()
	add_child(video_timer)
	
	# 设置3秒后停止视频
	video_timer.wait_time = 3.0
	video_timer.one_shot = true
	video_timer.timeout.connect(_on_video_timer_timeout)
	
	# 显示并播放视频
	VideoPlayer.visible = true
	VideoPlayer.play()
	
	# 启动计时器
	video_timer.start()

func _on_video_timer_timeout():
	# 停止视频
	VideoPlayer.stop()
	VideoPlayer.visible = false
	
	# 移除计时器
	video_timer.queue_free()
