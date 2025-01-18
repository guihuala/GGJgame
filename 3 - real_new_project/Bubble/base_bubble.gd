extends RigidBody2D

# 对话内容节点
@onready var text_label: Label = $sprite/Label
# 鼠标是否在气泡的判断区域内，如果在就可以戳破
var is_in_area: bool = false

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1

func _ready():
	# 配置刚体属性
	mass = bubble_mass
	gravity_scale = bubble_gravity

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
	AudioManager.play_sfx("bubble")
	queue_free()

func _on_button_pressed() -> void:
	on_destroy_bubble()
