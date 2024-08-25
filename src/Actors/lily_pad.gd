extends StaticBody2D
class_name LilyPad

signal activated

@onready var collision: CollisionShape2D = get_node("CollisionShape2D")
@onready var frog_sprite: Sprite2D = get_node("Frog")

var used: bool = false

func activate():
	collision.set_deferred("disabled", true)
	used = true
	frog_sprite.show()
	activated.emit()


func _on_level_restart(_reset_score: bool):
	collision.set_deferred("disabled", false)
	used = false
	frog_sprite.hide()