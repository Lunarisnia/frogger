extends Node2D
class_name ObstacleSpawner

@onready var timer: Timer = get_node("Timer")

@export var obstacles: Array[PackedScene]
@export var obstacle_speed: float = 100.0

@export var interval: float = 1.0
@export var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	timer.wait_time = randf_range(interval*0.4, interval)

func _on_timer_timeout() -> void:
	if len(obstacles) <= 0:
		return
	timer.wait_time = randf_range(interval*0.4, interval)
	var obstacle: PackedScene = obstacles[randi_range(0, len(obstacles) - 1)]
	var spawned_obstacle : MovingObstacle = obstacle.instantiate() as MovingObstacle
	add_child(spawned_obstacle)
	spawned_obstacle.global_position = global_position
	spawned_obstacle.start(direction, obstacle_speed)
