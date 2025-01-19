extends TabBar

# 引用按钮节点
@onready var bgm_button: TextureButton = $HBoxContainer/BGM
@onready var sfx_button: TextureButton = $HBoxContainer/sfx

# 定义纹理资源
@export var bgm_on_texture: Texture
@export var bgm_off_texture: Texture
@export var sfx_on_texture: Texture
@export var sfx_off_texture: Texture

# 保存原始音量值
var music_original_value: float = 1.2
var sound_effect_original_value: float = 1.2

# 音量是否静音的状态
var is_music_muted: bool = false
var is_sfx_muted: bool = false

func _ready():
	# 检查并初始化BGM音量状态
	var current_music_volume = AudioServer.get_bus_volume_db(1)
	is_music_muted = (current_music_volume <= -80)  # AudioServer的最小值通常为-80dB
	
	# 检查并初始化音效音量状态
	var current_sfx_volume = AudioServer.get_bus_volume_db(2)
	is_sfx_muted = (current_sfx_volume <= -80)
	
	# 根据当前状态更新BGM按钮纹理
	if bgm_button:
		if  is_music_muted:
			bgm_button.texture_normal = bgm_off_texture
		else :
			bgm_button.texture_normal = bgm_on_texture
	
	# 根据当前状态更新音效按钮纹理
	if sfx_button:
		if is_sfx_muted:
			sfx_button.texture_normal = sfx_off_texture
		else:
			sfx_button.texture_normal = sfx_on_texture


func set_volume(idx: int, value: float):
	# 设置音量
	AudioServer.set_bus_volume_db(idx, linear_to_db(value))


func _on_bgm_pressed() -> void:
	# 切换BGM音量
	if is_music_muted:
		# 恢复音量
		set_volume(1, music_original_value)
		is_music_muted = false
		
		# 切换回开启状态的纹理
		if bgm_button and bgm_on_texture:
			bgm_button.texture_normal = bgm_on_texture
	else:
		set_volume(1, 0)
		is_music_muted = true
		
		# 切换到静音状态的纹理
		if bgm_button and bgm_off_texture:
			bgm_button.texture_normal = bgm_off_texture
	
	# 播放按钮点击音效
	AudioManager.play_sfx("bubble2")


func _on_sfx_pressed() -> void:
	# 切换音效音量
	if is_sfx_muted:
		# 恢复音量
		set_volume(2, sound_effect_original_value)
		is_sfx_muted = false
		
		# 切换回开启状态的纹理
		if sfx_button and sfx_on_texture:
			sfx_button.texture_normal = sfx_on_texture
	else:
		set_volume(2, 0)
		is_sfx_muted = true
		
		# 切换到静音状态的纹理
		if sfx_button and sfx_off_texture:
			sfx_button.texture_normal = sfx_off_texture
	
	# 播放按钮点击音效
	AudioManager.play_sfx("bubble2")
