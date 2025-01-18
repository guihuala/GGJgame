extends Node2D

@onready var animator = $AnimatedSprite2D

func _ready() -> void:
	GameManager.salary_decrease.connect(play_animation_angry)
	
func play_animation_click() -> void:
	animator.play("click")

func play_animation_angry() -> void:
	animator.play("angry")
