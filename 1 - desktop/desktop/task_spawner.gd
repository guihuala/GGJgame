extends Node

@export var GameManager: Node

# 固定任务
var fixed_tasks = {
	# 时间点: 任务名称
	10.1: "晨会",
	12.1: "午餐",
	15.1: "下午茶",
}

# 随机任务
var random_tasks = [
	"紧急文件",
	"客户来访",
	"系统故障",
]

var spawn_timer: Timer

func _ready():
	# 创建并设置定时器
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = 1  # 每秒检查一次

func _on_game_manager_phase_changed(phase: int) -> void:
	if phase == GameManager.GamePhase.WORK:
		start_spawning()
	else:
		stop_spawning()

# 添加开始生成事件的函数
func start_spawning():
	spawn_timer.start()

# 添加停止生成事件的函数
func stop_spawning():
	spawn_timer.stop()

# 定时器超时回调
func _on_spawn_timer_timeout():
	# 检查固定事件
	spawn_fixed_task(GameManager.current_game_time)
	# 尝试生成随机事件
	try_spawn_random_task()

# 检查并生成固定任务
func spawn_fixed_task(game_time: float):
	# 定义误差范围
	var tolerance = 0.01
	# 遍历固定任务的时间点
	for fixed_time in fixed_tasks.keys():
		# 检查当前游戏时间是否接近某个固定时间点
		if abs(game_time - fixed_time) <= tolerance:
			var task_name = fixed_tasks[fixed_time]
			create_task(task_name)
			break

# 尝试生成随机任务
func try_spawn_random_task():
	if randf() < 0.8:  # 几率
		var task_name = random_tasks[randi() % random_tasks.size()]
		create_task(task_name)

# 创建任务
func create_task(task_name):
	print("事件：" + task_name)
