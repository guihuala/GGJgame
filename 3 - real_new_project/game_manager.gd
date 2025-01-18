extends Node
# 薪水
var current_salary: int = 0
# 通知UI更新的信号
signal salary_changed(salary:int)

enum GamePhase {
	PREPARE,    # 准备阶段
	WORK,       # 正常工作阶段 (9:30-18:30)
	OVERTIME,   # 加班阶段 (18:30-21:30)
	SETTLEMENT  # 结算阶段
}

# 信号
signal phase_changed(phase: GamePhase)
signal day_started(day: int)
signal day_ended(day: int)

# 常量
const WORK_START_TIME = 9.5  # 9:30
const WORK_END_TIME = 18.5   # 18:30
const DAY_END_TIME = 21.5    # 21:30
const DAY_DURATION = 180.0   # 3分钟实际时间
const TOTAL_DAYS = 5         # 总天数

# 状态变量
var current_phase: GamePhase = GamePhase.PREPARE
var current_day: int = 1
var current_game_time: float = WORK_START_TIME
var timer: Timer

func _ready():
	set_salary(500)
	setup_timer()
	start_day()
	
func setup_timer():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	# 计算实际时间到游戏时间的转换比例
	var real_time_step = 1.0  # 1秒实际时间
	timer.wait_time = real_time_step
	
func start_day():
	current_phase = GamePhase.PREPARE
	emit_signal("phase_changed", current_phase)
	emit_signal("day_started", current_day)
	
	# 延迟一段时间后开始工作阶段
	await get_tree().create_timer(3.0).timeout
	
	current_phase = GamePhase.WORK
	emit_signal("phase_changed", current_phase)
	timer.start()
	
func _on_timer_timeout():
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
	timer.stop()
	current_phase = GamePhase.SETTLEMENT
	emit_signal("phase_changed", current_phase)
	
	# 显示商店界面
	show_shop()
	
	# 等待商店关闭
	# await shop_closed
	
	# 进入下一天或结束游戏
	current_day += 1
	if current_day <= TOTAL_DAYS:
		current_game_time = WORK_START_TIME
		start_day()
	else:
		# end_game()
		pass
		
func show_shop():
	pass
	
# 任务管理
func spawn_task():
	match current_phase:
		GamePhase.WORK:
			# 正常工作时间的任务，完成获得薪水
			pass
		GamePhase.OVERTIME:
			# 加班时间的任务，失败扣薪水
			pass
			
# 薪水处理
func complete_task(reward: int):
	if current_phase == GamePhase.WORK:
		increase_salary(reward)
	
func fail_task(penalty: int):
	if current_phase in [GamePhase.WORK, GamePhase.OVERTIME]:
		decrease_salary(penalty)
		
# 增加薪水
func increase_salary(amount: int):
	current_salary += amount
	emit_signal("salary_changed",current_salary)
	
# 减少薪水
func decrease_salary(amount: int):
	current_salary -= amount
	if current_salary < 0:
		current_salary = 0
	emit_signal("salary_changed",current_salary)
	
# 获取薪水
func get_salary() -> int:
	return current_salary
	
# 设置薪水
func set_salary(amount: int):
	current_salary = amount
	emit_signal("salary_changed",current_salary)
