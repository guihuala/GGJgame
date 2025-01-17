extends Node

# 场景映射
var scene_map: Dictionary = {
}

var current_scene: Node = null

# 薪水
var current_salary: int = 0

# 通知UI更新的信号
signal salary_changed(new_salary: int)

func _ready() -> void:
	emit_signal("salary_changed", current_salary)

# 场景管理：切换场景
func switch_scene(scene_name: String):
	var scene_path = scene_map.get(scene_name)
	if scene_path:
		var new_scene = load(scene_path).instantiate()
		if current_scene:
			remove_scene(current_scene)
			delete_scene(current_scene)
		get_tree().root.add_child(new_scene)
		current_scene = new_scene
		print("Switched to scene: ", scene_name)
	else:
		print("Scene not found: ", scene_name)

# 隐藏场景
func hide_scene(scene: Node):
	if scene:
		scene.hide()

# 从场景树中移除场景
func remove_scene(scene: Node):
	if scene:
		get_tree().root.remove_child(scene)

# 删除场景
func delete_scene(scene: Node):
	if scene:
		scene.queue_free()

# 增加薪水
func increase_salary(amount: int):
	current_salary += amount
	emit_signal("salary_changed", current_salary)  # 发射信号

# 减少薪水
func decrease_salary(amount: int):
	current_salary -= amount
	if current_salary < 0:
		current_salary = 0
	emit_signal("salary_changed", current_salary)  # 发射信号

# 获取薪水
func get_salary() -> int:
	return current_salary

# 设置薪水
func set_salary(amount: int):
	current_salary = amount
	emit_signal("salary_changed", current_salary)  # 发射信号
