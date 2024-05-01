extends Node2D

signal in_area(isIn: bool)

var difficulty: float = 1.0
var difficultyIsSet: bool = false

func _ready() -> void:
	%Heat.get_node("Area2D").connect("area_entered", _on_heat_area_entered)
	%Heat.get_node("Area2D").connect("area_exited", _on_heat_area_exited)

func _process(_delta: float) -> void:
	# This feels so weird
	if !difficultyIsSet:
		%Heat.scale.y = %Heat.scale.y / difficulty
		difficultyIsSet = true

func _on_heat_area_entered(_area: Area2D) -> void:
	emit_signal("in_area", true)

func _on_heat_area_exited(_area: Area2D) -> void:
	emit_signal("in_area", false)
