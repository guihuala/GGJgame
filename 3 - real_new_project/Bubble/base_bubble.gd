extends RigidBody2D

# 对话内容节点
@onready var text_label: Label = $Label
# 鼠标是否在气泡的判断区域内，如果在就可以戳破
var is_in_area: bool = false

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1
# 薪水范围
@export var min_salary: int = 10
@export var max_salary: int = 50

@export var probabilty: float = 0.5
var is_long_press_bubble: bool = false
var is_dragging: bool = false
var should_staff_handle: bool = false
var drag_offset: Vector2 = Vector2.ZERO

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: Button = $Button

var is_long_pressing: bool


func _ready():
	# 配置刚体属性
	mass = bubble_mass
	gravity_scale = bubble_gravity
	
	animated_sprite_2d.visible = false
	button.button_down.connect(_on_button_button_down)
	button.button_up.connect(_on_button_button_up)
	
	if randf() < probabilty:
		animated_sprite_2d.visible = true
		is_long_press_bubble = true

# 处理拖拽输入
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# 鼠标左键按下
		if event.button_index == MOUSE_BUTTON_LEFT:
			# 检查鼠标是否在气泡上
			if button.get_global_rect().has_point(event.position):
				if event.pressed:
					# 开始拖拽
					is_dragging = true
					# 计算鼠标位置和气泡位置的偏移
					drag_offset = global_position - event.position
					should_staff_handle = false
				else:
					# 结束拖拽
					is_dragging = false
					should_staff_handle = true
	
	# 鼠标移动事件
	elif event is InputEventMouseMotion and is_dragging:
		# 更新气泡位置
		global_position = event.position + drag_offset
		# 拖拽时停止物理模拟
		freeze = true

# 销毁气泡
func on_destroy_bubble() -> void:
	# 生成随机薪水
	var random_salary = randi_range(min_salary, max_salary)
	
	# 增加随机数额的薪水
	GameManager.increase_salary(random_salary)
	
	# 查找场景中第一个 character 组的节点
	var character = get_tree().get_nodes_in_group("Character")[0]
	
	# 检查节点是否存在且有方法可调用
	if character:
		character.play_animation_click()
	
		
	
	# 销毁气泡
	GameManager.solved_bubble_num += 1
	queue_free()

func _on_button_button_down() -> void:
	if is_long_press_bubble:
		
		animated_sprite_2d.play("loading")
		AudioManager.play_sfx("long_press")
		is_long_pressing = true
		
		await animated_sprite_2d.animation_finished
		
		is_long_pressing = false
		
		AudioManager.play_sfx("bubble")
		on_destroy_bubble()
		
		AudioManager.sound_player.stream = null
	else:
		AudioManager.play_sfx("bubble")
		on_destroy_bubble()

func _on_button_button_up() -> void:
	# 结束拖拽
	is_dragging = false
	is_long_pressing = false
	# 恢复物理模拟
	freeze = false
	
	# 停止长按动画
	animated_sprite_2d.stop()
