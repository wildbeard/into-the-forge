extends Node2D

var difficulty: float = 1.0
var moveDown: float = 0
var lastMove: float = 0.0

func _process(delta: float) -> void:
	lastMove += delta
	moveDown += delta

	if lastMove >= 0.5:
		lastMove = 0
		var newPos: Vector2 = self._get_sweat_spot_position(false)
		var t: Tween = get_tree().create_tween()
		t.set_ease(Tween.EASE_IN_OUT)
		t.set_trans(Tween.TRANS_SINE)
		t.tween_property(%HeatSweetSpot, "global_position", newPos, 0.25)

	if Input.is_action_just_pressed("spacebar"):
		self._move_bar(true)
	elif moveDown >= 0.2:
		moveDown = 0
		self._move_bar(false)


func _get_upper_lower_bounds() -> Vector2:
	var lower: float = %HeatBar.global_position.y
	var upper: float = %HeatBar.global_position.y + (%HeatBar.texture.get_height() * %HeatBar.scale.y)

	return Vector2(lower, upper)

func _get_sweat_spot_position(shouldJump: bool) -> Vector2:
	var bounds: Vector2 = self._get_upper_lower_bounds()
	var currY: float = %HeatSweetSpot.global_position.y
	var sweetSpotHeight: float = %HeatSweetSpot.global_position.y + (%HeatSweetSpot.texture.get_height() * %HeatSweetSpot.scale.y)
	var newY: float = randf_range(bounds.x, bounds.y - sweetSpotHeight)

	return Vector2(%HeatSweetSpot.global_position.x, newY)

func _move_bar(moveUp: bool) -> void:
	var bounds: Vector2 = self._get_upper_lower_bounds()
	var newPos: Vector2 = Vector2(%YourBar.global_position.x, 0)
	var tweenTime: float = 0.25

	if !moveUp:
		newPos.y = bounds.y - (%YourBar.texture.get_height() * %YourBar.scale.y)
	else:
		var newY: float = %YourBar.global_position.y - 25
		tweenTime = 0.25

		if newY < 0:
			newY = 0

		newPos.y = newY

	var t: Tween = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(%YourBar, "global_position", newPos, tweenTime)
