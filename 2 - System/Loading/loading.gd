extends CanvasLayer

@onready var _animator: AnimationPlayer = $animator

func _ready():
	self.hide()

func load_scene(path):
	self.show()
	self.set_layer(100)
	
	_animator.play("changer")
	await _animator.animation_finished
	
	get_tree().change_scene_to_file(path)
	
	_animator.play_backwards("changer")
	await _animator.animation_finished
	
	self.set_layer(-1)
	self.hide()
