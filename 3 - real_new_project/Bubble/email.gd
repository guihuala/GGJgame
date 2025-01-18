extends RigidBody2D

@onready var close_sprite = $sprite
@onready var open_sprite = $sprite2
@export var EmailInfo: Array[PackedScene]

# 淡出动画的 Tween
var fade_tween: Tween

func _ready() -> void:
	open_sprite.hide()

func _on_button_pressed() -> void:
	# 显示打开的精灵
	open_sprite.show()
	close_sprite.hide()

	# 如果 EmailInfo 非空，随机实例化一个场景
	if EmailInfo and not EmailInfo.is_empty():
		var scene_to_spawn = EmailInfo[randi() % EmailInfo.size()]
		var new_instance = scene_to_spawn.instantiate()
			
		# 将新实例放置在当前物体的位置
		new_instance.global_position = global_position
			
		# 将新实例添加到场景中
		get_parent().add_child(new_instance)	
		
	# 创建淡出动画
	fade_tween = create_tween()
	
	# 设置动画属性
	fade_tween.tween_property(open_sprite, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# 动画结束后生成新场景并销毁当前物体
	fade_tween.tween_callback(func():

		
		# 销毁当前物体
		queue_free()
	)
