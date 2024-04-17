extends Resource

class_name CraftableItem

@export var inherits: CraftableItem = null
@export var name: String = ""
@export var description: String = ""

@export var requiredPoints: int = 20
@export var earlyPoint: int = 1
@export var perfectPoint: int = 2
@export var comboMultiplier: float = 0.125

@export var startingTexture: Texture = null
@export var finishedTexture: Texture = null

@export var difficulty: float = 1

const CAN_INHERIT = [
	"difficulty",
	"requiredPoints",
	"earlyPoint",
	"perfectPoint",
	"comboMultiplier"
]

func _hasInheritable() -> bool:
	return !!inherits
	
func _get(property):
	var val = self[property]
	if CAN_INHERIT.has(property) && _hasInheritable() && !!val:
		val = inherits[property]
	
	print(val)
	return val

func getDescription() -> String:
	if description != "":
		return description

	return "The humble %s" % name
