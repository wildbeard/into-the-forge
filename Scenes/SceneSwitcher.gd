extends Node

const DEFAULT_SCENE: PackedScene = preload("res://Scenes/MainMenu.tscn")

var currentScene: Node = null
var nextScene: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	currentScene = DEFAULT_SCENE.instantiate()
	currentScene.connect("switch_scene", _on_scene_switch_scene)
	add_child(currentScene)
	
func _on_scene_switch_scene(scene: Node) -> void:
	nextScene = scene
	_switchScene()

func _switchScene() -> void:
	currentScene.queue_free()
	currentScene = nextScene
	nextScene = null
	
	currentScene.connect("switch_scene", _on_scene_switch_scene)
	add_child(currentScene)
