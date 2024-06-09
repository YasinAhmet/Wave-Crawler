extends Timer
@onready var label: Label = get_node("Label")

func _process(delta):
	label.text = "%02d:%02d" % time_left_to_wave()

func time_left_to_wave():
	var timeLeft = time_left
	var minutesLeft = floor(time_left / 60)
	var secondsLeft = int(time_left) % 60
	return [minutesLeft, secondsLeft]

func turnLabelMode(to):
	label.visible = to

func _input(event):
	if event is InputEventKey and event.keycode == KEY_T and not event.echo:
		start(1)

func startAndWaitTimer(time):
	turnLabelMode(true)
	wait_time = time
	start()
	await timeout
	turnLabelMode(false)
	
