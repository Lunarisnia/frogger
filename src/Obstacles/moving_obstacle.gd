extends StaticBody2D
class_name MovingObstacle


var speed: float = 100.0
@export var direction: Vector2 = Vector2.RIGHT

var velocity: Vector2

func start(p_direction: Vector2, p_speed: float) -> void:
	direction = p_direction
	if direction.x > 0.0:
		rotation = PI
	speed = p_speed

func _process(delta: float) -> void:
	velocity = direction * speed
	position += velocity * delta
	if position.x > 1000.0 || position.x < -1000.0:
		queue_free()
