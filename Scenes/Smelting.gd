extends Node2D

var progress:float = 0.0
var outOfAreaTimer:float = 0.0
var outOfArea:bool = false

func _ready() -> void:
	%Heat.get_node("Area2D").connect("area_entered", _on_heat_area_entered)
	%Heat.get_node("Area2D").connect("area_exited", _on_heat_area_exited)

func _process(delta: float) -> void:
	if !outOfArea:
		%ProgressBar.value += 0.85
	else:
		outOfAreaTimer += delta

	if outOfAreaTimer > 0.5:
		%ProgressBar.value -= 0.5

func _on_heat_area_entered(area: Area2D) -> void:
	outOfArea = false

func _on_heat_area_exited(area: Area2D) -> void:
	outOfArea = true
