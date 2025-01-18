extends Label

@onready var label: Label = $"../Label"

func _ready() -> void:
	GameManager.salary_changed.connect(_on_game_manager_salary_changed)

func _on_game_manager_salary_changed(salary: int, amount: int) -> void:
	# 更新主标签文本
	text = "当前薪水: " + str(salary)
	label.text = str(amount)
	
	# 创建一个更复杂的漂浮动画
	var tween = create_tween()
	tween.set_parallel(true) # 允许同时进行多个动画
	
	# 位置动画
	tween.tween_property(label, "position",
		Vector2(randf_range(-20, 20), -50), # 更大的移动范围
		0.8 # 持续时间
	).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	# 透明度动画
	tween.tween_property(label, "modulate:a",
		0.0, # 目标透明度
		0.8 # 持续时间
	).set_delay(0.2) # 稍微延迟开始淡出
	
	# 缩放动画
	tween.tween_property(label, "scale",
		Vector2(1.2, 1.2), # 稍微放大
		0.2 # 快速放大
	).set_ease(Tween.EASE_OUT)
	
	# 动画结束后重置属性
	await tween.finished
	label.modulate.a = 1.0 # 重置透明度
	label.scale = Vector2.ONE # 重置缩放
