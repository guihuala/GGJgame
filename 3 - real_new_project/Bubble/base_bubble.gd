extends RigidBody2D

# 对话内容节点
@onready var text_label: Label = $sprite/Label

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1
@export var bounce_factor: float = 1.0  # 反弹系数
@export var friction_factor: float = 0.5  # 摩擦系数

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

# 设置对话框文本
func set_text(text: String):
	text_label.text = text

func on_destroy_bubble() -> void:
	#AudioManager.play_sfx("bubble")
	queue_free()

func _on_button_pressed() -> void:
	on_destroy_bubble()
