extends Control
var attachedPawn
func attachPawn(pawn):
	attachedPawn = pawn
	pawn.statsUpdated.connect(updateTexts.bind())
	updateTexts()

func updateTexts():
	$Damage.text = "Damage : " + str(myround(attachedPawn.damage, 1))
	$MaxHealth.text = "Max Health : " + str(myround(attachedPawn.max_health, 1))
	$MovementSpeed.text = "Movement Speed : " + str(myround(attachedPawn.movement_speed, 2))
	

func myround(value, count):
	return (round(value*pow(10, count))/pow(10, count))
