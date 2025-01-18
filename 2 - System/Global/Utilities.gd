extends Node

# 场景映射
var scene_map: Dictionary = {
}

var current_scene: Node = null

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
