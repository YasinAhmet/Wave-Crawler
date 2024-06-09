extends Label
var currentRound = 1


func NextRound():
	currentRound += 1
	text = "Round " + str(currentRound)
	$LevelLabel.text = "Level " + str(currentRound-1)

func ResetRound():
	Engine.time_scale = 1
	currentRound = 1
	text = "Round " + str(currentRound)
	$LevelLabel.text = "Level " + str(currentRound-1)
