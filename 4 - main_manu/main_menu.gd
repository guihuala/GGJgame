extends Control

# 配置文件路径
const CONFIG_PATH = "user://game_config.cfg"

# 播放视频的场景
@onready var setting_window = $SettingWindow

var is_info_show

func _ready():
	setting_window.hide()
	AudioManager.play_BGM("BGM2")


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

func _on_play_btn_pressed() -> void:
	if is_first_time():
		Utilities.switch_scene("Story")
	else :
		Utilities.switch_scene("GameScene")

func _on_setting_btn_pressed() -> void:
	if setting_window.visible == true:
		setting_window.visible = false
	else:
		setting_window.visible = true

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_texture_button_pressed() -> void:
	if !is_info_show:
		$AnimationPlayer.play("new_animation")
	else :
		$AnimationPlayer.play_backwards("new_animation")
	is_info_show = !is_info_show
