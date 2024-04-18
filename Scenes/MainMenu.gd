extends Node2D

signal switch_scene(scene: Node)

var files: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path = "res://Resources/Craftable/"
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	var fileName = dir.get_next()
	
	while fileName != "":
		var r = ResourceLoader.load("%s%s" % [path,fileName], "CraftableItem")
		files[r.name] = r
		fileName = dir.get_next()
		%ItemList.add_item(r.name, r.finishedTexture)

func _on_item_list_item_selected(index: int) -> void:
	# Since we're indexing resources via CraftableItem.name we can
	# hackishly use get_item_text(index) to get the key
	var itemName = %ItemList.get_item_text(index)
	var res = files[itemName]
	
	if !res:
		return
	
	var forgeScene: PackedScene = load("res://Scenes/Forge.tscn")
	var forge = forgeScene.instantiate()
	forge.craftable = res
	
	emit_signal("switch_scene", forge)
