extends TextureRect
@export var bubble_packed_scene_list:Array[PackedScene]
@export var location_list:Array[Marker2D]
@export var impulse_min: float
@export var impulse_max: float
 
@export var signal_bubble_probability: float
@export var double_bubble_probability: float
@export var triple_bubble_probability: float
@export var interval_min: float
@export var interval_max: float
var interval: float
@export var bubble_root:Node

func _ready() -> void:
	interval = randf_range(interval_min, interval_max)

func _process(delta: float) -> void:
	if GameManager.current_game_state != GameManager.GameState.RUNNING and GameManager.get_can_spawn_bubble():
		return
	
	interval -= delta
	if interval < 0:
		interval = randf_range(interval_min, interval_max)
		
		# 从随机位置生成气泡
		var spawn_location = location_list[randi() % location_list.size()]
		var bubble_scene: RigidBody2D = bubble_packed_scene_list[randi() % bubble_packed_scene_list.size()].instantiate()
		
		# 将气泡添加到指定的根节点
		bubble_root.add_child(bubble_scene)
		
		# 设置气泡的全局位置为生成点的位置
		bubble_scene.global_position = spawn_location.global_position
		
		# 赋予初速度
		var angle = randf_range(0, 180) 
		var radian = deg_to_rad(angle)  # 将角度转换为弧度
		var direction = Vector2(cos(radian), sin(radian))  #用cos和sin来获得单位方向向量
		bubble_scene.apply_impulse(-direction * randf_range(impulse_min, impulse_max))
