extends TextureRect

@export var bubble_packed_scene: PackedScene
@export var location_list:Array[Marker2D]


@export var speed_min: float
@export var speed_max: float
 
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
		var bubble_scene: RigidBody2D = bubble_packed_scene.instantiate()
		#实例化
		location_list[randi()%3].add_child(bubble_scene)
		#赋予初速度
		var angle = randf_range(0, 180)  # 随机生成一个0到360度的角度
		var radian = deg_to_rad(angle)  # 将角度转换为弧度
		var direction = Vector2(cos(radian), sin(radian))  #用cos和sin来获得单位方向向量
		bubble_scene.linear_velocity = randf_range(speed_min, speed_max) * direction
		
		
