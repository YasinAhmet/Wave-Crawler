extends CharacterBody3D
class_name Pawn

enum ACTION_STATE {IDLE, ATTACKING}

const JUMP_VELOCITY = 4.5
const MOVEMENT_LERP_SPEED = 0.35
var HITEFFECT = preload("res://Resources/Effects/Hit_BloodSplash.tscn")
const utilityLibrary = preload("res://MyUtilityLib.gd")

@onready var animaTree = get_node("Knight/AnimationTree");
@onready var animationPlayer = get_node("Knight/AnimationPlayer")
@export var attackAnimName = "Animation Name";
@export var deathAnimName = "Animation Name";
@export var attackList : AttackSet = AttackSet.new()

var currentState = ACTION_STATE.IDLE
var VELOCITY_DRAIN_SPEED = 0.15
@export var movement_speed = 1.2
@export var attackSpeed = 1.3
@export var attackCooldown = 0.8
@export var damage = 20.0
var health = 100
var max_health = 100
var dead = false;
var isAttackReady = false
var team = 0
var level = 1

signal pawn_death(pawn)
signal pawn_levelup(pawn)
signal pawn_gotDamage(pawn, amount)
signal pawn_recoveredHealth(pawn, amount)

var lastMovementWay = Vector2(0,0);
@onready var walkingEffect = get_node("WalkEffect")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var statesToWalk = [ACTION_STATE.IDLE]
var statesToRotate = [ACTION_STATE.IDLE]
var statesToAction = [ACTION_STATE.IDLE]

@onready var visionDetector = get_node("VisionDetector");
@onready var hitDetector = get_node("HitDetector");

func updateDamage():
	hitDetector.damage = damage

func _ready():
	add_to_group("Pawns")
	$AttackTimer.wait_time = attackCooldown
	updateDamage()

func moveInDirection(direction, force):
	if(!statesToWalk.has(currentState) && !force) || !is_on_floor() || dead:
		velocity.x = move_toward(velocity.x, 0, VELOCITY_DRAIN_SPEED)
		velocity.z = move_toward(velocity.z, 0, VELOCITY_DRAIN_SPEED)
		return
	
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	updateAnimationTree(velocity)
	move_and_slide()
	
	if abs(velocity.x) + abs(velocity.y) > 0:
		walkingEffect.set_emitting(true)
	else:
		walkingEffect.set_emitting(false)

func rotateBy(value, force):
	if(!statesToRotate.has(currentState) && !force):
		return
	rotate_y(value)

func lookAtTarget(target, force):
	if(!statesToRotate.has(currentState) && !force):
		return
	look_at(target.position)

func updateAnimationTree(byVelocity):
	var b = transform.basis
	var v_len = byVelocity.length()
	var v_nor = byVelocity.normalized()
	@warning_ignore("unassigned_variable")
	var vel : Vector2
	vel.x = b.x.dot(v_nor) * v_len
	vel.y = b.z.dot(v_nor) * v_len
	lastMovementWay = lastMovementWay.lerp(Vector2(vel.x, vel.y), MOVEMENT_LERP_SPEED)
	animaTree.set("parameters/IWR/blend_position", lastMovementWay)

func attack():
	if statesToAction.has(currentState) && isAttackReady:
		isAttackReady = false
		$AttackTimer.start()
		animationPlayer.play("CombatLibrary/" + attackAnimName, -1, attackSpeed)

func getHit(damage):
	health -= damage
	pawn_gotDamage.emit(self, damage)
	utilityLibrary.spawnParticles(HITEFFECT, get_node("Knight"), -global_transform.basis.get_euler().y)
	
	if dead:
		return
	
	if health <= 0:
		die()

func die():
	velocity = Vector3(0,0,0)
	set_collision_layer_value(4, false)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	hitDetector.enabled = false
	$Knight/Rig/Skeleton3D.physical_bones_start_simulation()
	dead = true
	pawn_death.emit()
	

func recoverHealth(amount):
	print("[HEALTH] health recovered.. " + str(amount) + " to " + str(max_health))
	health += amount
	if  health > max_health:
		health = max_health
	
	print("[HEALTH] health result.. " + str(health))
	pawn_recoveredHealth.emit(self, amount)

func _on_attack_timer_timeout():
	isAttackReady = true

func changeTeam(newTeam):
	team = newTeam
	visionDetector.ownerTeamID = team
	hitDetector.ownerTeamID = team

func levelUp(levels, deadIncluded):
	if(dead && !deadIncluded):
		return
	
	level += levels

signal statsUpdated
