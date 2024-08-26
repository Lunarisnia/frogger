extends Area2D
class_name Player

signal dead
signal moved
signal play_audio(audio: AudioStream, shift_pitch: bool)

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@export var death_particle: PackedScene

@export var death_audio: AudioStream
@export var jump_audio: AudioStream

const JUMP_SPEED = 64.0
const BOTTOM_LIMIT = 800.0
const TOP_LIMIT = 32.0

var target_position: Vector2
var is_moving: bool = false

var is_dead: bool = false

var tween: Tween
var velocity: Vector2

func _process(delta: float) -> void:
	if is_dead:
		return

	var overlapping: Array[Node2D] = get_overlapping_bodies()
	if len(overlapping) == 0 && !is_dead:
		_drown()
		return

	if tween == null || !tween.is_running():
		animated_sprite.play("idle")
		is_moving = false
		moved.emit()
		position += velocity * delta

	# TODO: Implement input buffer
	
func _unhandled_key_input(_event: InputEvent) -> void:
	if is_dead:
		return

	var direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if direction.x != 0.0 && !is_moving:
		if direction.x > 0.0:
			rotation_degrees = 90
		else:
			rotation_degrees = -90
		target_position = position + Vector2(direction.x * JUMP_SPEED, 0.0)
		target_position.y = clamp(target_position.y, TOP_LIMIT, BOTTOM_LIMIT)
		_hop()
	elif direction.y != 0.0 && !is_moving:
		if direction.y < 0.0:
			rotation_degrees = 0
		else:
			rotation_degrees = 180
		target_position = position + Vector2(0.0, direction.y * JUMP_SPEED)
		target_position.y = clamp(target_position.y, TOP_LIMIT, BOTTOM_LIMIT)
		_hop()

	if !direction.is_zero_approx():
		animated_sprite.play("jump")
		is_moving = true

func _hop():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, 1.0 / 10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	play_audio.emit(jump_audio, true)

func _drown():
	is_dead = true
	dead.emit()

var steppable_count: int = 0
func _on_body_entered(body: Node2D) -> void:
	if body is SteppableObstacle:
		steppable_count += 1
		velocity = (body as SteppableObstacle).velocity
	elif body is MovingObstacle:
		is_dead = true
		dead.emit()
	elif body is LilyPad:
		var lily_pad: LilyPad = body as LilyPad
		lily_pad.activate()

func _on_body_exited(body: Node2D) -> void:
	if body is SteppableObstacle:
		steppable_count -= 1
		if steppable_count <= 0:
			velocity = Vector2.ZERO
			steppable_count = 0

func _on_game_manager_respawn() -> void:
	is_dead = false
	show()

func _on_dead() -> void:
	hide()
	var part: GPUParticles2D = death_particle.instantiate() as GPUParticles2D
	get_parent().add_child(part)
	part.global_position = global_position
	part.show()
	part.emitting = true
	play_audio.emit(death_audio, true)
