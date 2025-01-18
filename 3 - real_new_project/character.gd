extends Node2D

@onready var animator = $AnimationPlayer

func play_animation() -> void:
	animator.play("new_animation")
