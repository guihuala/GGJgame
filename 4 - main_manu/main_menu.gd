extends Control

# 配置文件路径
const CONFIG_PATH = "user://game_config.cfg"

# 播放视频的场景
@onready var video_player = $VideoStreamPlayer
@onready var setting_window = $SettingWindow

func _ready():
	setting_window.hide()
	
	# 检查是否是第一次启动游戏
	if is_first_time():
		# 播放介绍视频
		play_intro_video()
	else:
		_on_video_finished()

# 检查是否是第一次启动
func is_first_time() -> bool:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	# 如果配置文件不存在，说明是第一次启动
	if err != OK:
		# 创建配置文件，标记已启动
		config.set_value("game", "first_launch", false)
		config.save(CONFIG_PATH)
		return true
	
	# 返回是否是第一次启动
	return config.get_value("game", "first_launch", true)

# 播放介绍视频
func play_intro_video():
	# 连接视频播放完成信号
	video_player.connect("finished", _on_video_finished)
	
	# 显示并播放视频
	video_player.visible = true
	video_player.play()
	

# 视频播放完成后的回调
func _on_video_finished():
	# 隐藏视频播放器
	video_player.visible = false

func _on_play_btn_pressed() -> void:
	Utilities.switch_scene("GameScene")

func _on_setting_btn_pressed() -> void:
	setting_window.show()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
