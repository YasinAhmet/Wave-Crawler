extends Node
class_name Pawn_Controller

const SENSIVITY = 0.006;
@onready var ownedPawn: Pawn = get_node("Pawn")
@onready var timer = get_node("/root/GlobalTimer")
const utilityLibrary = preload("res://MyUtilityLib.gd")
var respawnTime = 5

static var player 

func _ready():
	player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ownedPawn.changeTeam(2)
	ownedPawn.pawn_gotDamage.connect(healthChange.bind())
	ownedPawn.pawn_recoveredHealth.connect(healthChange.bind())
	ownedPawn.pawn_death.connect(gameover.bind())
	$Pawn/HealthBar.updateHealthBar(ownedPawn.health, ownedPawn.max_health)
	ownedPawn.hitDetector.dealtDamageToEnemy.connect(ownedPawn.utilityLibrary.setTimeScaleForLimitedTime.bind(1, 0.7, self))
	$Pawn/ThirdPersonCamera/StatsVisualizer.attachPawn(ownedPawn)

func _process(delta):
	if Input.is_action_pressed("Attack"):
		ownedPawn.attack()
		utilityLibrary.changeMouseMode(Input.MOUSE_MODE_CAPTURED)
		
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		ownedPawn.rotateBy(-event.relative.x * SENSIVITY, false)

func _physics_process(delta):
	walk();

func healthChange(pawn, damage):
	$Pawn/HealthBar.updateHealthBar(ownedPawn.health, ownedPawn.max_health)
	
func walk():
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = ( get_viewport().get_camera_3d().transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	ownedPawn.moveInDirection(direction*7.5, false)

func gameover():
	get_node("/root/MainMenu").turn(true)
	Engine.time_scale = 0.05
