extends Label

enum GamePhase {
	PREPARE,    # 准备阶段
	WORK,       # 正常工作阶段 (9:30-18:30)
	OVERTIME,   # 加班阶段 (18:30-21:30)
	SETTLEMENT  # 结算阶段
}

# 保存当前天数和阶段
var current_day: int = 1
var current_phase: int = GamePhase.PREPARE

func _ready() -> void:
	GameManager.phase_changed.connect(_on_game_manager_phase_changed)
	GameManager.day_started.connect(_on_game_manager_day_started)
	
func _on_game_manager_day_started(day: int) -> void:
	current_day = day
	update_text()

func _on_game_manager_phase_changed(phase: int) -> void:
	current_phase = phase
	update_text()

func update_text() -> void:
	var day_text = "第" + str(current_day) + "天"
	var phase_text = ""
	var phase_color = Color(0.7, 0.7, 0.7)  # 默认灰色
	
	match current_phase:
		GamePhase.PREPARE:
			phase_text = "准备阶段：\n检查今日工作"
			phase_color = Color(0.5, 0.5, 1)  # 浅蓝色
		
		GamePhase.WORK:
			phase_text = "工作阶段：\n开始你的工作"
			phase_color = Color(0, 1, 0)  # 绿色
		
		GamePhase.OVERTIME:
			phase_text = "加班阶段：\n小心不要犯错"
			phase_color = Color(1, 0.5, 0)  # 橙色
		
		GamePhase.SETTLEMENT:
			phase_text = "结算阶段：\n查看今日收益"
			phase_color = Color(1, 0, 0)  # 红色
		
		_:
			phase_text = "未知阶段"
			phase_color = Color(0.7, 0.7, 0.7)  # 灰色
	
	# 组合天数和阶段文字
	text = day_text + " - " + phase_text
	
	# 设置颜色
	add_theme_color_override("font_color", phase_color)
