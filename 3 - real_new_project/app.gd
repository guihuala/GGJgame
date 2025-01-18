extends TextureRect

@export var bubble_packed_scene: PackedScene
@export var location_list: Array[Marker2D]
@export var impulse_min: float
@export var impulse_max: float
 
@export var signal_bubble_probability: float
@export var double_bubble_probability: float
@export var triple_bubble_probability: float
@export var interval: float

# 果冻弹跳动画参数
@export var jelly_scale_max: float = 1.3  # 最大缩放
@export var jelly_duration: float = 0.5  # 动画总时长
@export var jelly_frequency: float = 4.0  # 弹跳频率

var timer: float

func _ready() -> void:
	timer = interval

func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		timer = interval
		spawn_bubble()

func spawn_bubble():
	var bubble_scene: RigidBody2D = bubble_packed_scene.instantiate()
	
	# 随机选择生成位置
	var spawn_location = location_list[randi() % location_list.size()]
	spawn_location.add_child(bubble_scene)
	
	# 赋予初速度
	var angle = randf_range(0, 180) 
	var radian = deg_to_rad(angle)  # 将角度转换为弧度
	var direction = Vector2(cos(radian), sin(radian))  # 用cos和sin来获得单位方向向量
	bubble_scene.apply_impulse(-direction * randf_range(impulse_min, impulse_max))

func create_jelly_animation():
	# 创建缩放动画
	var tween = create_tween()
	
	# 保存原始缩放
	var original_scale = scale
	
	# 果冻弹跳动画
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	
	# 弹跳效果
	tween.tween_property(self, "scale", Vector2(jelly_scale_max, jelly_scale_max), jelly_duration / 2)
	tween.tween_property(self, "scale", original_scale, jelly_duration / 2)
	
	# 动画完成后继续循环
	tween.tween_callback(create_jelly_animation)
