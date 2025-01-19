extends RigidBody2D


var is_in_area: bool = false

# 物理属性
@export var bubble_mass: float = 1.0
@export var bubble_gravity: float = -1

# 薪水范围
@export var min_salary: int = 10
@export var max_salary: int = 30

var duration: float = 3.0  # 持续时间
@onready var timer: Timer = $Timer
@onready var animation = $AnimatedSprite2D

# 预定义动画名称数组
var animation_names: Array[String] = [
	"anim_1", 
	"anim_2", 
	"anim_3", 
	"anim_4"
]

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = duration
	timer.start()
	
	# 配置刚体属性
	mass = bubble_mass
	gravity_scale = bubble_gravity
	
	# 通过索引播放动画
	play_animation_by_index(GameManager.random_index)

# 通过索引播放动画的方法
func play_animation_by_index(index: int):
	# 确保索引在有效范围内
	if index >= 0 and index < animation_names.size():
		animation.play(animation_names[index])

# 销毁气泡
func on_destroy_bubble() -> void:
	# 查找场景中第一个 character 组的节点
	var character = get_tree().get_nodes_in_group("Character")[0]
	
	# 检查节点是否存在且有方法可调用
	if character:
		character.play_animation_click()
	
	# 播放音效
	AudioManager.play_sfx("Warn")
	
	GameManager.unfocus_num += 1
	# 销毁气泡
	queue_free()

# 按钮点击事件
func _on_button_pressed() -> void:
	# 生成随机薪水
	var random_salary = randi_range(min_salary, max_salary)
	
	GameManager.decrease_salary(random_salary)
	
	# 播放销毁特效
	on_destroy_bubble()

func _on_timer_timeout():
	queue_free()
