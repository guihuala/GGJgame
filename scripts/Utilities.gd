extends Node

var scene_map: Dictionary = {
	"MainMenu": "res://scenes/GameScenes/main_menu.tscn",
	"GameScene": "res://scenes/GameScenes/sample_game.tscn",
}     # 场景索引与路径的映射
@export var is_persistence: bool = false   # 是否启用持久化

const PATH = "user://settings.cfg"         # 配置文件路径
var config: ConfigFile

func _ready():
	config = ConfigFile.new()

	# 保存所有控制动作及其对应的事件（如按键绑定）
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			config.set_value("Controls", action, InputMap.action_get_events(action)[0])

	# 设置默认的视频设置
	config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value("Video", "borderless", false)
	config.set_value("Video", "vsync", DisplayServer.VSYNC_ENABLED)

	# 设置默认的音频设置（3个音量通道，范围为0到1）
	for i in range(3):
		config.set_value("Audio", str(i), 0.5)

	# 如果启用了持久化功能，则加载配置数据
	if is_persistence:
		load_data()

# 数据持久化：保存配置到文件
func save_data():
	if is_persistence:
		config.save(PATH)

func load_data():
	if config.load("user://settings.cfg") != OK:
		save_data()
		return
	load_control_settings()
	load_video_settings()

func load_control_settings():
	var keys = config.get_section_keys("Controls")
	for action in InputMap.get_actions():
		if keys.has(action):
			var value = config.get_value("Controls", action)
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, value)

func load_video_settings():
	var screen_type = config.get_value("Video", "fullscreen")
	DisplayServer.window_set_mode(screen_type)
	var borderless = config.get_value("Video", "borderless")
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderless)
	var vsync_index = config.get_value("Video", "vsync")
	DisplayServer.window_set_vsync_mode(vsync_index)

# 场景管理：切换场景
func switch_scene(scene_name: String):
	var scene_path = scene_map.get(scene_name)
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
