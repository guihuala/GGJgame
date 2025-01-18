extends Label

@export var main_node: Node

func _ready():
	# 连接信号
	if main_node:
		main_node.connect("salary_changed",_on_salary_changed)

# 信号回调函数
func _on_salary_changed(new_salary: int):
	text = "当前薪水: " + str(new_salary)
