extends CollisionObject3D

@export var health = 40
@export var damagedMesh : ArrayMesh = null
@export var defaultMesh : ArrayMesh = null
var HITEFFECT = preload("res://Resources/Effects/Hit_WoodEffect.tscn")
const utilityLibrary = preload("res://MyUtilityLib.gd")
@onready var meshInstance = get_node("Mesh")

var destroyed = false

func _ready():
	meshInstance.mesh = defaultMesh

func getHit(damage):
	utilityLibrary.spawnParticles(HITEFFECT, self, -global_transform.basis.get_euler().y)
	
	if destroyed:
		call_deferred("free")
		return
	
	health -= damage
	if health <= 0:
		meshInstance.mesh = damagedMesh
		destroyed = true
