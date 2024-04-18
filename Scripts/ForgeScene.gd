extends Node2D

@export var craftable: CraftableItem = null

@onready var outOfBounds: Area2D = $OutOfBounds
@onready var hammer: Sprite2D = $Hammer
@onready var itemSprite: Sprite2D = $ItemSprite
@onready var progressBar: TextureProgressBar = $CanvasLayer/ProgressBar
@onready var itemLabel: RichTextLabel = $CanvasLayer/ItemName
@onready var markerScene: PackedScene = preload("res://Scenes/SwingMarker.tscn")
@onready var floatingTextScene: PackedScene = preload("res://Scenes/FloatingText.tscn")

var currentMarkerCount: int = 0
var perfectHits: int = 0
var combo: int = 0
var early: int = 0
var late: int = 0
var markers: Array = []
var currentPoints: int = 0

func _ready():
	progressBar.min_value = 0
	progressBar.max_value = craftable.requiredPoints
	itemSprite.texture = craftable.startingTexture
	
	itemLabel.text = "[center]%s[/center]" % craftable.name
	
	# If we immediately start and spawn the markerScene var isn't
	# yet available in _on_spawner_spawn()
	$Spawner.minDelay = 0.5
	$Spawner.maxDelay = 0.85
	$Spawner/Timer.start(0.5)

func _process(_delta):
	if currentPoints >= craftable.requiredPoints:
		$Spawner/Timer.stop()
		itemSprite.texture = craftable.finishedTexture

		for m in markers:
			self._removeMarkerFromScene(m)
		return
	
	if Input.is_action_just_pressed("spacebar"):
		self._animateHammer()

		var m = markers.filter(func(n: Node): return n && !n.is_queued_for_deletion()).pop_front()
		self._setHitTypeOnNode(m)
		
		if m && m.hitType > -1:
			self._removeMarkerFromScene(m)
			var point = 0
			var hitText = null

			match m.hitType:
				0:
					combo = 0
					point = craftable.earlyPoint
					early += craftable.earlyPoint
					hitText = "Early"
				1:
					perfectHits += 1
					point = craftable.perfectPoint + floor((currentPoints * combo * craftable.comboMultiplier))
					combo += 1
					hitText = "Perfect"
				2:
					combo = 0
					late += 1
					hitText = "Late"
					
			if point + currentPoints > craftable.requiredPoints:
				currentPoints = craftable.requiredPoints
			else:
				currentPoints += point
			
			var s: Sprite2D = m.get_node("Sprite2D")
			var p: Vector2 = m.global_position
			p.y -= s.get_rect().size.x * s.scale.x
			p.x -= 15
			self._addHitText(hitText, p)
		else:
			self._removeMarkerFromScene(m)

	self._updateProgressBar()
	self._updateSpriteHeat()
	
func _removeMarkerFromScene(marker: Node):
	if !marker:
		return

	var idx = markers.find(marker)
	markers.remove_at(idx)
	marker.destroy()
	
func _updateProgressBar():
	progressBar.value = currentPoints
	$CanvasLayer/DebugText.text = "Item: " + craftable.name + "\nDesc: " + craftable.getDescription() + "\nLate: " + str(late) + "\nEarly: " + str(early) + "\nPerfect: " + str(perfectHits) + "\nCombo: " + str(combo)

func _updateSpriteHeat():
	var perc = 1 - (float(currentPoints) / float(craftable.requiredPoints))
	itemSprite.material.set_shader_parameter("opacity", perc)

func _animateHammer() -> void:
	var t = get_tree().create_tween()
	var start = hammer.rotation_degrees
	t.tween_property(hammer, "rotation", deg_to_rad(start - 90), 0.15)
	t.tween_property(hammer, "rotation", deg_to_rad(start), 0.25)

func _addHitText(text: String, pos: Vector2) -> void:
	var t = create_tween().set_parallel(true)
	var txt = floatingTextScene.instantiate()
	var label = txt.get_node("Label")
	label.text = text
	label.global_position = pos
	add_child(txt)
	t.tween_property(label, "position", Vector2(pos.x - randf_range(-25, 25), pos.y - 25), 0.5)
	t.tween_property(label, "rotation", deg_to_rad(randf_range(-25, 25)), 0.5)
	t.tween_property(label, "modulate", Color("#FFF", 0), 0.5)
	t.tween_property(label, "scale", Vector2(0.75, 0.75), 0.5)
	t.chain().tween_callback(txt.queue_free)

func _setHitTypeOnNode(marker: Node):
	if !marker:
		return -1

	var mArea = marker.get_node("Area2D")
	var hitType = -1
	
	if !mArea:
		return hitType
	
	var earlyA = $SwingArea/Early.get_overlapping_areas()
	var lateA = $SwingArea/Late.get_overlapping_areas()
	var perfectA = $SwingArea/Perfect.get_overlapping_areas()
		
	if mArea in earlyA:
		hitType = 0
	elif mArea in lateA:
		hitType = 2
	elif mArea in perfectA && !earlyA.has(mArea) && !lateA.has(mArea):
		hitType = 1
	
	marker.hitType = hitType

func _on_outOfBounds_area_entered(area: Area2D):
	self._removeMarkerFromScene(area.owner)

func _on_spawner_spawn():
	if !markerScene:
		return

	var marker = markerScene.instantiate()
	marker.global_position = $StartingPosition.global_position
	marker.targetPosition = outOfBounds.global_position
	marker.difficulty = craftable.difficulty
	markers.push_back(marker)
	add_child(marker)
