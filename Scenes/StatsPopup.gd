extends Node2D

signal button_pressed(btn: String)

@onready var itemSprite: Sprite2D = $CanvasLayer/ItemSprite
@onready var menuBtn: Button = %MenuBtn
@onready var retryBtn: Button = %RetryBtn

var craftable: CraftableItem = null
var stats: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if !craftable || stats.is_empty():
		print("Error: Stats or Craftable not available")
		return

	%ItemName.text = craftable.name
	itemSprite.texture = craftable.finishedTexture

	for key: String in stats:
		# %StatsRichLabel.text += "%s: %i\n" % [key.capitalize(), stats[key]]
		%StatsRichLabel.text += key.capitalize() + ": " + str(stats[key]) + "\n"

	menuBtn.connect("pressed", _on_menuBtn_pressed)
	retryBtn.connect("pressed", _on_retryBtn_pressed)

func _on_menuBtn_pressed() -> void:
	print("menu")
	emit_signal("button_pressed", "menu")

func _on_retryBtn_pressed() -> void:
	print("retry")
	emit_signal("button_pressed", "retry")
