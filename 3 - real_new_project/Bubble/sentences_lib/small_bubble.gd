extends Label

func _ready() -> void:
	var lib: Array = SmallSentencesLib.sentences_lib
	text = lib[randi() % lib.size()]
