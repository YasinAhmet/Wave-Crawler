extends Panel

enum UPGRADE_TYPE {damage, current_health, health, movement_speed}
var upgradeType = UPGRADE_TYPE.damage
var bonusPercentage = 5.0

const MAX_BONUS = 100.0
const MIN_BONUS = 20.0

func _ready():
	setupUpgrade(getRandomUpgradeType(), getRandomBonus())

func getRandomUpgradeType():
	return UPGRADE_TYPE.keys()[randi() % UPGRADE_TYPE.size()]

func getRandomBonus():
	return randi_range(MIN_BONUS, MAX_BONUS)

func setupUpgrade(type, percentage):
	upgradeType = type
	bonusPercentage = percentage * processUpgradeRates()
	$BonusText.text = str("Increases your " + upgradeType + " by " + str(bonusPercentage) + "%.")

signal onUpgradePicked

func processUpgradeRates():
	match str(upgradeType):
		"current_health":
			return 1.0

		"movement_speed":
			return 0.2

		"health":
			return 0.5
		
		"damage":
			return 0.6
	

func upgradePicked():
	var targetPawn = Pawn_Controller.player.ownedPawn
	print("[UPGRADE] Upgrade picked.. " + upgradeType)
	
	match str(upgradeType):
		"current_health":
			targetPawn.recoverHealth((targetPawn.max_health/100)*bonusPercentage)

		"movement_speed":
			applyPercentageIncrement(targetPawn, "movement_speed", bonusPercentage)
			targetPawn.VELOCITY_DRAIN_SPEED += 0.075

		"health":
			applyPercentageIncrement(targetPawn, "max_health", bonusPercentage)
			applyPercentageIncrement(targetPawn, "health", bonusPercentage/3)
			targetPawn.recoverHealth(0)
		
		"damage":
			applyPercentageIncrement(targetPawn, "damage", bonusPercentage)
			targetPawn.updateDamage()
	
	onUpgradePicked.emit()

func applyPercentageIncrement(targetPawn, type, amount):
	var targetStatValue = targetPawn.get(str(type))
	targetPawn.set(str(type), targetStatValue + (targetStatValue/100)*amount)
	targetPawn.statsUpdated.emit()

func _on_button_button_down():
	upgradePicked()
