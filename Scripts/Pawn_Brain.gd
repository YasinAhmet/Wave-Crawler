extends Node
@onready var ownedPawn : Pawn = get_node("Pawn");
var reachOffset = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	ownedPawn.changeTeam(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ownedPawn == null || ownedPawn.dead:
		return
	thinkAction()
	pass

func thinkAction():
	var firstVisibleTarget = ownedPawn.visionDetector.getFirstTarget()
	var firstHittableTarget = ownedPawn.hitDetector.getFirstTarget()
	var inRange = firstHittableTarget != null && ownedPawn.global_position.distance_to(firstHittableTarget.global_position) < reachOffset
	
	if firstHittableTarget != null:
		if inRange:
			ownedPawn.velocity = Vector3(0,0,0)
			ownedPawn.lookAtTarget(firstHittableTarget, false)
			ownedPawn.attack()
		else:
			chase(firstHittableTarget)
			return
	else:
		if firstVisibleTarget != null:
			chase(firstVisibleTarget)

func chase(target):
	ownedPawn.lookAtTarget(target, false)
	ownedPawn.moveInDirection(target.global_position - ownedPawn.global_position, false)
	pass
