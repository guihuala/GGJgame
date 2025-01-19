extends Label

func _ready() -> void:
	var lib: Array = LargeSentencesLib.sentences_lib
	text = lib[randi() % lib.size()]
