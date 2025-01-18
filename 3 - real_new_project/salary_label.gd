extends Label

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var label: Label = $"../Label"

func _ready() -> void:
	GameManager.salary_changed.connect(_on_game_manager_salary_changed)
	
func _on_game_manager_salary_changed(salary: int, amount: int) -> void:
	text = "当前薪水: " + str(salary)
	label.text = str(amount)
	
	create_tween().tween_property(label,"global_position",Vector2(
		randf_range(-5,5),
		randf_range(-5, -10)
	),1.2).as_relative()
	
	animation_player.play("pop_up")
