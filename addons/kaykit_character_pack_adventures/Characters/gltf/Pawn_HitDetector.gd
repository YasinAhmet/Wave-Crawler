extends Area3D

const arrayLibrary = preload("res://MyUtilityLib.gd")
var targets_in_range = []

var ownerTeamID = 0
var blacklist: Array
signal dealtDamageToEnemy
var damage = 0
var enabled = true

func dealDamageToAllInRange():
	if enabled == false:
		return
	
	for body in targets_in_range:
		dealDamage(body, damage)
func dealDamage(body, damage):
	if body.has_method('getHit') && !body.dead:
		body.getHit(damage)
		if body.dead:
			dealtDamageToEnemy.emit()
func _on_body_entered(body):
	var hasTeam = body.get("team")
	if !blacklist.has(body.get_instance_id()) && (!hasTeam || body.team != ownerTeamID):
		targets_in_range.push_back(body)
func _on_body_exited(body):
	arrayLibrary.RemoveFromList(targets_in_range, body)
func getFirstTarget():
	if targets_in_range.size() > 0:
		for target in targets_in_range:
			var hasTeam = target.get("team")
			if !blacklist.has(target.get_instance_id()) && hasTeam && target.team != ownerTeamID:
				return target
	return

func _on_ready():
	blacklist.push_back(self.get_parent().get_instance_id())
