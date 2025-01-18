extends Label

@export var main_node: Node


func _on_game_manager_salary_changed(salary: int) -> void:
	text = str(salary)
