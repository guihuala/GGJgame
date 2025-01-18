extends Control
class_name WindowBase

# 拖拽相关变量
var should_drag: bool = false
var offset: Vector2

# 拖拽逻辑
func _process(delta: float) -> void:
	if should_drag:
		global_position = get_global_mouse_position() - offset

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
