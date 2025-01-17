extends Panel

enum InteractionState {
	IDLE,
	DRAGGING,
	LONG_PRESS,
}

var interaction_state = InteractionState.IDLE
var offset = Vector2()
var press_start_pos = Vector2()
var long_press_timer = 0.0
var long_press_threshold = 0.5  # 长按时间阈值（秒）
var drag_threshold = 2  # 拖动的最小距离阈值

# 屏幕边界碰撞相关
var screen_margin = 20  # 屏幕边缘吸附距离
var screen_size : Vector2

@onready var title_bar : Control = $TitleBar
@onready var title_label : Label = $TitleBar/Title

func _ready():
	# 获取屏幕大小
	screen_size = get_viewport_rect().size
	hide()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var global_mouse_pos = event.global_position
			if event.pressed:
				# 记录按下的初始位置
				press_start_pos = global_mouse_pos
				
				# 重置长按计时器
				long_press_timer = 0.0
				
				# 检查是否点击在窗口区域
				if get_global_rect().has_point(global_mouse_pos):
					interaction_state = InteractionState.DRAGGING
					offset = get_global_mouse_position() - global_position
			else:
				# 松开鼠标时的处理
				if interaction_state == InteractionState.DRAGGING:
					# 判断是否为点击（未超过拖动阈值）
					if (global_mouse_pos - press_start_pos).length() < drag_threshold:
						# 点击关闭
						_on_close_button_pressed()
				
				# 重置状态
				interaction_state = InteractionState.IDLE
				long_press_timer = 0.0

func _process(delta):
	# 处理拖动
	if interaction_state == InteractionState.DRAGGING:
		var new_pos = get_global_mouse_position() - offset
		
		# 屏幕边界吸附和碰撞处理
		new_pos.x = clamp(new_pos.x, 0, screen_size.x - size.x)
		new_pos.y = clamp(new_pos.y, 0, screen_size.y - size.y)
		
		global_position = new_pos
		
		# 处理长按
		long_press_timer += delta
		if long_press_timer >= long_press_threshold:
			interaction_state = InteractionState.LONG_PRESS

# 关闭按钮处理方法
func _on_close_button_pressed() -> void:
	queue_free()

# 长按触发的操作 留空，可以后续实现具体小游戏逻辑
func _on_long_press_action() -> void:
	print("长按触发")
