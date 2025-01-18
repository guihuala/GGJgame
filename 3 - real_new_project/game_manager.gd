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

# 通知UI更新的信号
signal salary_changed(salary:int)
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

# 开始游戏
func start_game():
	# 重置游戏状态
	current_day = 1
	current_game_time = WORK_START_TIME
	current_phase = GamePhase.PREPARE
	
	# 设置初始薪水
	set_salary(500)
	
	# 设置游戏状态为进行中
	change_game_state(GameState.RUNNING)
	
	# 设置计时器
	setup_timer()
	
	# 开始第一天
	start_day()

# 结束游戏
func end_game():
	# 停止计时器
	if timer:
		timer.stop()
	
	# 设置游戏状态为已结束
	change_game_state(GameState.FINISHED)
	
	# 可以添加游戏结束的其他逻辑，如显示总成绩等
	print("游戏结束，总薪水：", current_salary)

func set_can_spawn_bubble(value:bool) -> void:
	can_spawn_bubble = value

func get_can_spawn_bubble() -> bool:
	return can_spawn_bubble

# 改变游戏状态的方法
func change_game_state(new_state: GameState):
	current_game_state = new_state
	emit_signal("game_state_changed", current_game_state)

func setup_timer():
	# 如果计时器已存在，先移除
	if timer:
		timer.queue_free()
	
	# 创建新的计时器
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# 设置计时器间隔（1秒）
	var real_time_step = 1.0
	timer.wait_time = real_time_step

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

func end_day():
	# 停止计时器
	timer.stop()
	current_phase = GamePhase.SETTLEMENT
	emit_signal("phase_changed", current_phase)
	
	# 显示商店界面
	show_shop()
	
	# 进入下一天或结束游戏
	current_day += 1
	if current_day <= TOTAL_DAYS:
		current_game_time = WORK_START_TIME
		start_day()
	else:
		# 达到总天数，结束游戏
		end_game()

func show_shop():
	# 显示商店的具体实现
	pass

# 薪水处理（保持原有逻辑）
func increase_salary(amount: int):
	current_salary += amount
	emit_signal("salary_changed", current_salary)

func decrease_salary(amount: int):
	current_salary -= amount
	if current_salary < 0:
		current_salary = 0
	emit_signal("salary_changed", current_salary)
	emit_signal("salary_decrease")

func get_salary() -> int:
	return current_salary

func set_salary(amount: int):
	current_salary = amount
	emit_signal("salary_changed", current_salary)
