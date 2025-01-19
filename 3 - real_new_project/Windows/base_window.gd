extends Control
class_name WindowBase

# 拖拽相关变量
var should_drag: bool = false
var offset: Vector2

# 动画相关变量
var popup_tween: Tween
var is_animating: bool = false

# 拖拽逻辑
func _process(_delta: float) -> void:
	if should_drag:
		# 更新位置并检查窗口边缘
		var new_pos = get_global_mouse_position() - offset
		global_position = clamp_to_viewport(new_pos)

# 将窗口位置限制在可视区域内
func clamp_to_viewport(pos: Vector2) -> Vector2:
	# 获取视口大小
	var viewport_rect = get_viewport_rect()
	
	# 计算窗口边缘
	var min_x = 0
	var min_y = 0
	var max_x = viewport_rect.size.x - size.x
	var max_y = viewport_rect.size.y - size.y
	
	# 限制位置
	return Vector2(
		clamp(pos.x, min_x, max_x),
		clamp(pos.y, min_y, max_y)
	)

# 输入处理
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				# 开始拖拽
				should_drag = true
				offset = get_global_mouse_position() - global_position
			else:
				# 结束拖拽
				should_drag = false

# 设置内容方法
func set_content(content: Control) -> void:
	# 将内容添加为子节点
	add_child(content)
	content.anchor_right = 1.0
	content.anchor_bottom = 1.0
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

# 居中窗口
func center_window() -> void:
	# 在父容器中居中
	if get_parent():
		position = (get_parent().size - size) / 2
	else:
		# 在视口中居中
		position = (get_viewport_rect().size - size) / 2
	
	# 确保窗口在可视区域内
	global_position = clamp_to_viewport(global_position)

# 弹出窗口动画
func popup(centered: bool = true) -> void:
	# 如果正在动画中，直接返回
	if is_animating:
		return
	
	# 居中（如果需要）
	if centered:
		center_window()
	
	# 重置缩放和透明度
	scale = Vector2(0.3, 0.3)
	modulate.a = 0.0
	visible = true
	
	# 创建弹出动画
	is_animating = true
	popup_tween = create_tween()
	
	# 缩放和透明度动画
	popup_tween.set_parallel(true)
	popup_tween.tween_property(self, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	popup_tween.tween_property(self, "modulate:a", 1.0, 0.3)\
		.set_trans(Tween.TRANS_LINEAR)
	
	# 动画结束回调
	popup_tween.tween_callback(func(): is_animating = false)

# 隐藏窗口动画
func hide_window() -> void:
	# 如果正在动画中，直接返回
	if is_animating:
		return
	
	# 创建隐藏动画
	is_animating = true
	popup_tween = create_tween()
	
	# 缩放和透明度动画
	popup_tween.set_parallel(true)
	popup_tween.tween_property(self, "scale", Vector2(0.3, 0.3), 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	popup_tween.tween_property(self, "modulate:a", 0.0, 0.3)\
		.set_trans(Tween.TRANS_LINEAR)
	
	# 动画结束回调
	popup_tween.tween_callback(func(): 
		is_animating = false
		visible = false
		scale = Vector2.ONE
	)
