extends Node

# 场景映射
var scene_map: Dictionary = {
	"GameScene": ("res://3 - real_new_project/desktop.tscn"),
	"MainMenu": ("res://4 - mainmanu/MainMenu.tscn")
}

var current_scene: Node = null

# 场景管理：切换场景
func switch_scene(scene_name: String):
	var scene_path = scene_map.get(scene_name)
	print(scene_path)
	Loading.load_scene(scene_path)

# 隐藏场景
func hide_scene(scene):
	scene.hide()

# 从场景树中移除场景
func remove_scene(scene):
	get_tree().root.remove_child(scene)

# 删除场景
func delete_scene(scene):
	scene.queue_free()
