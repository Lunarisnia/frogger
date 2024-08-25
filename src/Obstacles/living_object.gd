extends AnimatedSprite2D
class_name LivingObject

func _on_execute_action(animation_name: String):
	play(animation_name)