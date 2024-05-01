extends Node2D

var difficulty: float = 1
var inArea: bool = false
var outOfAreaTimer: float = 0.0
var progress: float = 0.0

@onready var HeatBars: Node2D = $HeatBars

func _ready() -> void:
	HeatBars.connect("in_area", _on_in_area_change)
	HeatBars.difficulty = difficulty

func _process(delta: float) -> void:
	if inArea:
		%ProgressBar.value += 0.95
		outOfAreaTimer = 0
	else:
		outOfAreaTimer += delta

	if outOfAreaTimer >= 0.75:
		%ProgressBar.value -= 0.65

func _on_in_area_change(isIn: bool) -> void:
	inArea = isIn
