extends SteppableObstacle
class_name LivingSteppable

@onready var timer: Timer = get_node("Timer")
@onready var collision: CollisionShape2D = get_node("CollisionShape2D")

signal execute_action(animation_name: String)

var will_action: bool = false

func _ready():
	will_action = randi_range(0, 10) > 5
	if will_action:
		timer.start(2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func _action():
	while true:
		print("HEI")
		if will_action:
			var should_dive: bool = randi_range(0, 10) > 6
			if should_dive:
				execute_action.emit("action")
				print("I STILL MOVE")
				await get_tree().create_timer(1.0).timeout
				execute_action.emit("idle")
			else:	
				await get_tree().create_timer(1.0).timeout

func _on_timer_timeout() -> void:
	var should_dive: bool = randi_range(0, 10) > 6
	collision.set_deferred("disabled", false)
	if should_dive:
		execute_action.emit("action")
		collision.disabled = true
		await get_tree().create_timer(1.0).timeout
		execute_action.emit("idle")
	else:	
		await get_tree().create_timer(1.0).timeout
	