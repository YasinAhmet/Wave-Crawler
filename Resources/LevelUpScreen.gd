extends Panel
signal levelUpFinished
const utilityLibrary = preload("res://MyUtilityLib.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	var upgrades = get_node("Upgrades").get_children()
	for upgrade in upgrades:
		upgrade.onUpgradePicked.connect(finishLevelUp.bind())

func finishLevelUp():
	Engine.time_scale = 1
	levelUpFinished.emit()

func _process(delta):
	utilityLibrary.changeMouseMode(Input.MOUSE_MODE_VISIBLE)	
