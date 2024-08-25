extends Control
class_name ScoreCounter

@onready var label: Label = get_node("Label")

func _ready() -> void:
	label.text = "SCORE: 0"

func _on_score_changed(new_score: int) -> void:
	label.text = "SCORE: " + str(new_score)