extends Label

@export var main_node: Node

func _ready() -> void:
	GameManager.salary_changed.connect(_on_game_manager_salary_changed)

func _on_game_manager_salary_changed(salary: int) -> void:
	text = "当前薪水: " + str(salary)
