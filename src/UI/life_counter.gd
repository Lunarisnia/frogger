extends Control
class_name LifeCounter

@export var lifes: Array[TextureRect]

var life_count: int = 3

func _on_life_changed(new_life:int) -> void:
	for l in lifes:
		l.hide()

	for i in new_life:
		lifes[i].show()
