extends Node2D

var hitType: int = 3
var difficulty: float = 0
var targetPosition: Vector2 = Vector2.ZERO

func destroy() -> void:
	queue_free()

func _process(delta):
	var speed = 25 + (25 * difficulty)
	global_position = global_position.move_toward(targetPosition, delta * speed)
