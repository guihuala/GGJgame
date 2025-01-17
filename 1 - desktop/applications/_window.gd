extends Control

enum InteractionState {
	IDLE,
	DRAGGING,
}

var interaction_state = InteractionState.IDLE
var offset = Vector2()
var press_start_pos = Vector2()
var long_press_timer = 0.0
var drag_threshold = 2  # 拖动的最小距离阈值

# 倒计时相关变量
@export var countdown_duration = 10.0  # 倒计时总时间（秒）
var current_countdown = 0.0  # 当前倒计时
var remaining_countdown  # 失焦时保存的剩余时间
var is_countdown_active = false  # 是否激活倒计时

# 抖动相关变量
var shake_intensity = 0.0
var shake_timer = 0.0
var shake_frequency = 10.0  # 抖动频率
var shake_offset = Vector2.ZERO  # 保存抖动偏移

# 屏幕边界碰撞相关
var screen_margin = 20  # 屏幕边缘吸附距离
var screen_size : Vector2

# 薪水相关的变量
var salary_succeed:int
var salary_failed:int

@onready var title_bar : Control = $TitleBar
@onready var title_label : Label = $TitleBar/Title
@onready var countdown_label : Label = $TitleBar/CountdownLabel

func _ready():
	# 获取屏幕大小
	screen_size = get_viewport_rect().size
	
	current_countdown = countdown_duration
	remaining_countdown = countdown_duration
	
	# 初始化倒计时标签
	if countdown_label:
		countdown_label.text = "%.1f" % countdown_duration
	
	hide()

func _gui_input(event):
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
					# 激活窗口并启动倒计时
					if(!is_countdown_active):
						activate_window()
					interaction_state = InteractionState.DRAGGING
					offset = get_global_mouse_position() - (global_position + shake_offset)
				else:
					deactivate_window()
			else:
				# 重置状态
				interaction_state = InteractionState.IDLE
				long_press_timer = 0.0

func _process(delta):
	
	handle_window_shake(delta)
	
	update_window_state(current_countdown)
	
	# 处理倒计时
	if is_countdown_active:
		current_countdown -= delta
		
		# 更新倒计时显示
		if countdown_label:
			countdown_label.text = "%.1f" % max(0.0, current_countdown)
		
		# 倒计时结束
		if current_countdown <= 0:
			pass
			
	# 处理拖动
	if interaction_state == InteractionState.DRAGGING:
		var new_pos = get_global_mouse_position() - offset
		
		# 屏幕边界吸附和碰撞处理
		new_pos.x = clamp(new_pos.x, 0, screen_size.x - size.x)
		new_pos.y = clamp(new_pos.y, 0, screen_size.y - size.y)
		
		global_position = new_pos - shake_offset

# 根据剩余时间更新窗口状态
func update_window_state(remaining_time: float):
	var percent_remaining = remaining_time / countdown_duration
	
	if percent_remaining > 0.5:
		# 轻度抖动
		shake_intensity = 3.0
		modulate = Color(1, 1, 1, 1)
	elif percent_remaining > 0.3:
		# 中度抖动
		shake_intensity = 5.0
		modulate = Color(1, 0.8, 0.6, 1)  # 橙色
	elif percent_remaining <= 0.1:
		# 疯狂抖动并变红
		shake_intensity = 8.0
		modulate = Color(1, 0.4, 0.4, 1)  # 红色

# 处理窗口抖动
func handle_window_shake(delta):
	if shake_intensity > 0:
		shake_timer += delta * shake_frequency
		
		# 生成随机抖动偏移
		shake_offset = Vector2(
			sin(shake_timer * 2) * shake_intensity, 
			cos(shake_timer * 2) * shake_intensity
		)
	else:
		shake_offset = Vector2.ZERO

# 激活窗口
func activate_window():
	is_countdown_active = true
	
	# 如果有保存的剩余时间，使用剩余时间
	if remaining_countdown > 0:
		current_countdown = remaining_countdown
	
	# 可以添加激活时的视觉效果
	modulate = Color(1, 1, 1, 1)  # 完全不透明
	z_index = 1  # 置于其他窗口之上
	
	# 重置抖动
	shake_offset = Vector2.ZERO

# 取消激活窗口
func deactivate_window():
	# 保存当前剩余时间
	remaining_countdown = current_countdown
	
	is_countdown_active = false
	
	modulate = Color(1, 1, 1, 0.5)  # 半透明
	z_index = 0  # 恢复普通层级

func _on_close_btn_pressed() -> void:
	hide()
