extends Label

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var label: Label = $"../Label"

func _ready() -> void:
	GameManager.salary_changed.connect(_on_game_manager_salary_changed)
	
func _on_game_manager_salary_changed(salary: int, amount: int) -> void:
	text = "当前薪水: " + str(salary)
	if sign(amount) == 1:
		label.text = "+" + str(amount)
	else:
		label.text = str(amount)
	animation_player.play("pop_up")
