extends RigidBody2D

# 对话内容节点
@onready var text_label: Label = $sprite/Label
@onready var progress_bar: ProgressBar = $ProgressBar

# 长按相关变量
var is_pressing: bool = false
var press_duration: float = 0.0
@export var long_press_duration: float = 1.0  # 长按需要的时间

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1
@export var bounce_factor:float = 1.0
@export var friction_factor:float = 1.0

func _ready():
	# 配置刚体属性
	mass = bubble_mass
	gravity_scale = bubble_gravity
	
	# 创建物理材质
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = bounce_factor
	physics_material.friction = friction_factor
	
	# 应用物理材质
	physics_material = physics_material
	
	# 初始化进度条
	if progress_bar:
		progress_bar.visible = false
		progress_bar.max_value = long_press_duration
		progress_bar.value = 0

func _process(delta):
	# 处理长按逻辑
	if is_pressing:
		press_duration += delta
		
		# 更新进度条
		if progress_bar:
			progress_bar.visible = true
			progress_bar.value = press_duration
		
		# 检查是否达到长按时间
		if press_duration >= long_press_duration:
			on_destroy_bubble()

# 通用初始化方法，便于外部配置
func initialize(
	text: String = "", 
	init_position: Vector2 = Vector2.ZERO, 
	init_mass: float = bubble_mass,
	init_gravity: float = bubble_gravity,
	init_bounce: float = bounce_factor,
	init_friction: float = friction_factor
) -> void:
	# 设置文本
	if text != "":
		set_text(text)
	
	# 设置位置
	if init_position != Vector2.ZERO:
		global_position = init_position
	
	# 更新物理属性
	mass = init_mass
	gravity_scale = init_gravity
	
	# 重新创建物理材质
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = init_bounce
	physics_material.friction = init_friction
	physics_material = physics_material

# 设置对话框文本
func set_text(text: String):
	text_label.text = text

func on_destroy_bubble() -> void:
	#AudioManager.play_sfx("bubble")
	queue_free()

# 长按开始
func _on_button_pressed() -> void:
	# on_destroy_bubble()
	pass

func _on_button_button_down() -> void:
	is_pressing = true
	press_duration = 0.0

func _on_button_button_up() -> void:
	# 如果未达到长按时间，重置
	is_pressing = false
	press_duration = 0.0
	
	# 隐藏进度条
	if progress_bar:
		progress_bar.visible = false
		progress_bar.value = 0
