extends AnimatedSprite2D

var area_2d: Area2D
var animated_sprite_2d: AnimatedSprite2D

var is_busy: bool = false

func _ready() -> void:
	area_2d = get_child(0)
	animated_sprite_2d = get_child(1)
	area_2d.body_entered.connect(_body_entered)
	animated_sprite_2d.visible = false
	
func _body_entered(bubble: RigidBody2D):
	if not is_busy:
		if bubble.should_staff_handle:
			is_busy = true
			bubble.visible = false
			bubble.set_collision_mask_value(1, false)
			
			animated_sprite_2d.visible = true
			animated_sprite_2d.play("loading")
			
			await animated_sprite_2d.animation_finished
			
			animated_sprite_2d.visible = false
			
			bubble.on_destroy_bubble()
			is_busy = false
