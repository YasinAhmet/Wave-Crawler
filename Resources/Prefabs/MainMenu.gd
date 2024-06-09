extends Control
const utilityLibrary = preload("res://MyUtilityLib.gd")

func _ready():
	Engine.time_scale = 0.01

func _process(delta):
	if visible:
		grab_click_focus()
		utilityLibrary.changeMouseMode(Input.MOUSE_MODE_VISIBLE)

func turn(on):
	visible = on
	match visible:
		true:
			utilityLibrary.changeMouseMode(Input.MOUSE_MODE_VISIBLE)	
		false:
			utilityLibrary.changeMouseMode(Input.MOUSE_MODE_CAPTURED)	

func _on_continue_button_down():
	get_node("/root/RoundManager").ResetRound()
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	turn(false)
