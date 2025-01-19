extends Panel

# 引用暂停按钮
@onready var pause_button: TextureButton = $Audio/HBoxContainer/Pause

# 导出纹理资源
@export var pause_on_texture: Texture
@export var pause_off_texture: Texture

# 暂停状态
var is_paused: bool = false

# 引用游戏管理器（假设存在）
@export var game_manager: Node

# 保存暂停前的场景树状态
var previous_process_mode: Node.ProcessMode = Node.PROCESS_MODE_INHERIT

func _ready():
	# 初始化按钮纹理
	if pause_button:
		pause_button.texture_normal = pause_off_texture
		
	panel.hide()

func _on_pause_pressed() -> void:
	is_paused = !is_paused
	
	if is_paused:
		# 暂停游戏
		pause_game()
	else:
		# 恢复游戏
		resume_game()
	
	# 切换按钮纹理
	update_pause_button_texture()
	
	# 播放按钮点击音效
	AudioManager.play_sfx("bubble")

func pause_game():
	# 保存当前场景的处理模式
	previous_process_mode = get_tree().root.process_mode
	
	# 停止游戏逻辑，但不影响音频
	get_tree().root.process_mode = Node.PROCESS_MODE_DISABLED
	
	# 停止游戏计时器
	if game_manager and game_manager.has_method("pause_timer"):
		game_manager.pause_timer()

func resume_game():
	# 恢复场景树的处理模式
	get_tree().root.process_mode = previous_process_mode
	
	# 重新启动游戏计时器
	if game_manager and game_manager.has_method("resume_timer"):
		game_manager.resume_timer()

func update_pause_button_texture():
	if pause_button:
		if is_paused:
			pause_button.texture_normal = pause_on_texture
		else:
			pause_button.texture_normal = pause_off_texture


@onready var panel: Panel = $"../Panel"
@export var scene: PackedScene

func _on_button_pressed() -> void:
	panel.show()
	get_tree().paused = true
	
func _on_确定_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)

func _on_取消_pressed() -> void:
	get_tree().paused = false
	panel.hide()
	
