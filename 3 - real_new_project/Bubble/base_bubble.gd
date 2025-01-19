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

@export var probabilty: float
var is_long_press_bubble: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: Button = $Button

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
	
	# 播放音效
	AudioManager.play_sfx("bubble")
	
	# 销毁气泡
	queue_free()


func _on_button_button_down() -> void:
	if is_long_press_bubble:
		animated_sprite_2d.play("loading")
		await animated_sprite_2d.animation_finished
		on_destroy_bubble()
	else:
		on_destroy_bubble()

func _on_button_button_up() -> void:
	animated_sprite_2d.stop()
