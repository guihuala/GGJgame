extends RigidBody2D

# 对话内容节点
@onready var text_label: Label = $Label
# 鼠标是否在气泡的判断区域内，如果在就可以戳破
var is_in_area: bool = false

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1

func _ready():
	# 配置刚体属性
	mass = bubble_mass
	gravity_scale = bubble_gravity

# 设置对话框文本
func set_text(text: String):
	text_label.text = text

func on_destroy_bubble() -> void:
	#AudioManager.play_sfx("bubble")
	queue_free()

func _on_button_pressed() -> void:
	on_destroy_bubble()
