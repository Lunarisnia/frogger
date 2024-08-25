extends Node2D
class_name GameManager

signal respawn
signal life_changed(new_life: int)
signal score_changed(new_score: int)
signal level_restart(reset_score: bool)

@export var spawn_point: Marker2D 
@export var player: Player

var lily_pad_count: int

var player_score: int = 0
var player_life: int = 3

var last_position: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lily_pad_count = get_child_count()
	last_position = player.position.y
	
func _on_lily_pad_activated():
	lily_pad_count -= 1
	player.tween.stop()
	player.global_position = spawn_point.position
	last_position = player.position.y
	if lily_pad_count <= 0:
		level_restart.emit(false)

func _on_player_dead() -> void:
	player_life -= 1
	life_changed.emit(player_life)
	if player_life <= 0:
		level_restart.emit(true)
		await get_tree().create_timer(0.2).timeout
		respawn.emit()
	else:
		player.tween.stop()
		player.global_position = spawn_point.position
		player.rotation = 0.0
		await get_tree().create_timer(0.2).timeout
		respawn.emit()


func _on_player_moved() -> void:
	if player.position.y < last_position:
		last_position = player.position.y
		player_score += 10
		score_changed.emit(player_score)

func _on_level_restart(reset_score: bool) -> void:
	if reset_score:
		player_score = 0
		score_changed.emit(player_score)
		player_life = 3
		life_changed.emit(player_life)
	lily_pad_count = get_child_count()
	player.tween.stop()
	player.global_position = spawn_point.position
	player.rotation = 0.0
	last_position = player.position.y