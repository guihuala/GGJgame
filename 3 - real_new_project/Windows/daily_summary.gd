extends WindowBase

@onready var day_text = $Day
@onready var salary_text = $Text/Salary
@onready var focus_text = $Text/Focus
@onready var grade_text = $Text/Grade

# 自动关闭计时器
var auto_close_timer: Timer

func _ready() -> void:
	# 连接游戏阶段变化信号，注意这里接收参数
	GameManager.phase_changed.connect(update_daily_summary)
	
	# 创建自动关闭计时器
	auto_close_timer = Timer.new()
	add_child(auto_close_timer)
	auto_close_timer.one_shot = true
	auto_close_timer.timeout.connect(_on_auto_close_timeout)

# 修改方法签名，接收传入的阶段参数
func update_daily_summary(phase):
	if phase != GameManager.GamePhase.SETTLEMENT:
		hide()
		return
	
	var daily_statistic = GameManager.get_daily_statistics(GameManager.current_day)
	
	day_text.text = "day - " + str(GameManager.current_day)
	salary_text.text = "工资 ： " + str(daily_statistic.salary)
	focus_text.text = "分心率 : " + str("%.2f" %  (1- daily_statistic.focus))
	grade_text.text = "绩效评估 : " + str(GameManager.DailyGrade.keys()[daily_statistic.grade])
	
	show()
	
	# 启动自动关闭计时器
	auto_close_timer.start(5.0)  # 5秒后自动关闭

func _on_auto_close_timeout():
	# 自动关闭窗口并开始下一天
	hide()
	GameManager.start_next_day()
