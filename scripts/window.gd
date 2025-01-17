extends Panel

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
var countdown_duration = 10.0  # 倒计时总时间（秒）
var current_countdown = 0.0  # 当前倒计时
var is_countdown_active = false  # 是否激活倒计时

# 屏幕边界碰撞相关
var screen_margin = 20  # 屏幕边缘吸附距离
var screen_size : Vector2

@onready var title_bar : Control = $TitleBar
@onready var title_label : Label = $TitleBar/Title
@onready var countdown_label : Label = $TitleBar/CountdownLabel

func _ready():
	# 获取屏幕大小
	screen_size = get_viewport_rect().size
	
	# 初始化倒计时标签
	if countdown_label:
		countdown_label.text = "%.1f" % countdown_duration

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
					# 激活窗口并启动倒计时
					activate_window()
					
					interaction_state = InteractionState.DRAGGING
					offset = get_global_mouse_position() - global_position
			else:
				
				# 重置状态
				interaction_state = InteractionState.IDLE
				long_press_timer = 0.0


func _process(delta):
	# 处理倒计时
	if is_countdown_active:
		current_countdown -= delta
		
		# 更新倒计时显示
		if countdown_label:
			countdown_label.text = "%.1f" % max(0.0, current_countdown)
		
		# 倒计时结束
		if current_countdown <= 0:
			deactivate_window()
	
	# 处理拖动
	if interaction_state == InteractionState.DRAGGING:
		var new_pos = get_global_mouse_position() - offset
		
		# 屏幕边界吸附和碰撞处理
		new_pos.x = clamp(new_pos.x, 0, screen_size.x - size.x)
		new_pos.y = clamp(new_pos.y, 0, screen_size.y - size.y)
		
		global_position = new_pos

# 激活窗口
func activate_window():
	is_countdown_active = true
	current_countdown = countdown_duration
	
	# 可以添加激活时的视觉效果
	modulate = Color(1, 1, 1, 1)  # 完全不透明
	z_index = 1  # 置于其他窗口之上

# 取消激活窗口
func deactivate_window():
	is_countdown_active = false
	current_countdown = 0.0
	
	# 可以添加取消激活时的视觉效果
	modulate = Color(1, 1, 1, 0.5)  # 半透明
	z_index = 0  # 恢复普通层级

func _on_close_btn_pressed() -> void:
	queue_free()
