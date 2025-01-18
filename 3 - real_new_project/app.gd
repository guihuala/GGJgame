extends TextureRect

@export var bubble_packed_scene: PackedScene
@export var location_list: Array[Marker2D]
@export var impulse_min: float
@export var impulse_max: float

@export var signal_bubble_probability: float
@export var double_bubble_probability: float
@export var triple_bubble_probability: float
@export var interval: float

var timer: float

func _ready() -> void:
	timer = interval

func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		timer = interval
		spawn_bubbles()

func spawn_bubbles():
	# 根据概率决定生成气泡数量
	var bubble_count = determine_bubble_count()
	
	for _i in range(bubble_count):
		var bubble_scene: RigidBody2D = bubble_packed_scene.instantiate()
		
		# 随机选择生成位置
		var spawn_location = location_list[randi() % location_list.size()]
		spawn_location.add_child(bubble_scene)
		
		# 随机设置气泡属性
		var text = generate_random_text()
		var init_mass = randf_range(0.5, 2.0)
		var init_gravity = randf_range(-1.5, -0.5)
		var init_bounce = randf_range(0.5, 1.0)
		var init_friction = randf_range(0.2, 0.7)
		
		# 初始化气泡
		bubble_scene.initialize(
			text, 
			spawn_location.global_position, 
			init_mass, 
			init_gravity, 
			init_bounce, 
			init_friction
		)
		
		# 赋予初速度
		var angle = randf_range(0, 180) 
		var radian = deg_to_rad(angle)  # 将角度转换为弧度
		var direction = Vector2(cos(radian), sin(radian))  # 用cos和sin来获得单位方向向量
		bubble_scene.apply_impulse(-direction * randf_range(impulse_min, impulse_max))

func determine_bubble_count() -> int:
	var rand_value = randf()
	if rand_value < signal_bubble_probability:
		return 1
	elif rand_value < signal_bubble_probability + double_bubble_probability:
		return 2
	elif rand_value < signal_bubble_probability + double_bubble_probability + triple_bubble_probability:
		return 3
	return 1  # 默认返回1个

func generate_random_text() -> String:
	var texts = [
		"Hello!",
		"Nice day!",
		"Stay cool!",
		"Wow!",
		"Hey there!",
		"Bubble time!",
		"Greetings!"
	]
	return texts[randi() % texts.size()]
