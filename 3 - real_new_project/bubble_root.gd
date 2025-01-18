extends Node

# 最大气泡数量
@export var max_bubble_count: int = 10

func _process(delta: float) -> void:
	_on_check_timer_timeout()

func _on_check_timer_timeout():
	# 检查当前子节点数量
	var current_bubble_count = get_child_count()
	
	print(current_bubble_count)

	# 如果气泡数量超过最大限制
	if current_bubble_count > max_bubble_count:
		GameManager.set_can_spawn_bubble(false)
	else:
		GameManager.set_can_spawn_bubble(true)

# 可选：清理超出数量的气泡
func clean_excess_bubbles():
	var bubbles = get_children()
	
	# 按添加顺序删除多余的气泡
	while get_child_count() > max_bubble_count:
		var oldest_bubble = bubbles.pop_front()
		if oldest_bubble:
			oldest_bubble.queue_free()
