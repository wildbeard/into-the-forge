extends Node

signal spawn

@onready var timer: Timer = $Timer

var minDelay: float = 0.75
var maxDelay: float = 1.25

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("spawn")
	timer.connect("timeout", _on_spawner_timeout)

func _on_spawner_timeout():
	emit_signal("spawn")
	timer.start(randf_range(minDelay, maxDelay))
