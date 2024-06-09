extends Area3D
const DEFAULT_HOSTILEPAWNTYPE = preload("res://Resources/Prefabs/Pawn/hostile_pawn.tscn")
const DEFAULT_LEVELUPSCREEN = preload("res://Resources/Prefabs/level_up_screen.tscn")
const utilityLibrary = preload("res://MyUtilityLib.gd")
@onready var spawnPoints = get_node("SpawnPoints").get_children() 
var spawnedThings : Array
var waveStrength = 1
var waveGrowth = 1
var waveInterval = 5
@onready var timer = get_node("/root/GlobalTimer")

func onWaveOver():
	print("[WAVE] Wave over...")
	get_tree().call_group("Pawns", "levelUp", 1, false)
	waveStrength += waveGrowth
	
	await get_tree().create_timer(0.5).timeout
	var levelUpScreen = DEFAULT_LEVELUPSCREEN.instantiate()
	self.add_child(levelUpScreen)
	
	Engine.time_scale = 0.1
	utilityLibrary.changeMouseMode(Input.MOUSE_MODE_VISIBLE)	
	await levelUpScreen.levelUpFinished
	levelUpScreen.queue_free()
	utilityLibrary.changeMouseMode(Input.MOUSE_MODE_CAPTURED)	

	await get_tree().create_timer(1).timeout
	get_node("/root/RoundManager").NextRound()
	
	await get_tree().create_timer(0.5).timeout
	throwWave(waveStrength)

func throwWave(waveSize):
	await timer.startAndWaitTimer(waveInterval + waveStrength)
	
	for i in waveSize:
		if self != null:
			await utilityLibrary.wait(0.3, self)
			spawnHostilePawnRandomly()

func spawnHostilePawnRandomly():
	var newPawn = spawnThingRandomly(DEFAULT_HOSTILEPAWNTYPE).get_node("Pawn")
	newPawn.pawn_death.connect(on_Pawn_Dead.bind(newPawn))
	spawnedThings.push_front(newPawn)

func spawnThingRandomly(thing):
	if spawnPoints.size() <= 0:
		spawnPoints = get_node("SpawnPoints").get_children() 
	
	if spawnPoints.size() <= 0:
		return
	
	var spawnpoint = findRandomSpawnPoint()
	utilityLibrary.RemoveFromList(spawnPoints, spawnpoint)
	return utilityLibrary.spawnObjectAtLocation(thing, spawnpoint.global_position, self)

func findRandomSpawnPoint():
	return spawnPoints.pick_random()

func on_Pawn_Dead(pawn):
	print("[PAWN] A pawn is dead!")
	
	if areAllDead():
		for thing in spawnedThings.duplicate():  
			await utilityLibrary.wait(0.5, self)
			var thingToRemove = thing
			thingToRemove.queue_free()
			utilityLibrary.RemoveFromList(spawnedThings, thingToRemove)
		onWaveOver()
	

func areAllDead():
	for thing in spawnedThings:
		if !thing.dead:
			return false
	
	return true

func _on_ready():
	throwWave(1)
