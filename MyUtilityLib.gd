extends Object

static func RemoveFromList(list, obj):
	for n in range(list.size()):
		if(list[n] == obj):
			list.remove_at(n)
			return

static func spawnParticles(particles, affectedObj, radian):
	var rng = RandomNumberGenerator.new()
	var effect = spawnObjectAtLocation(particles, affectedObj.global_position + Vector3(0, affectedObj.scale.y/2, 0), affectedObj.get_tree().get_current_scene())
	
	effect.rotate_y(radian)
	effect.emitting = true

static func spawnObjectAtLocation(object, location, tree):
	var instance = object.instantiate()
	tree.add_child(instance)
	instance.global_position = location
	instance.basis = Basis()
	return instance

static func wait(seconds: float, keyRef) -> void:
	await keyRef.get_tree().create_timer(seconds).timeout

static func changeMouseMode(mouseMode):
	Input.set_mouse_mode(mouseMode)

static func setTimeScaleForLimitedTime(seconds, timeScale, keyRef):
	Engine.time_scale = timeScale
	await keyRef.get_tree().create_timer(seconds).timeout
	Engine.time_scale = 1
