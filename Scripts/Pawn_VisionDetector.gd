extends Area3D
const arrayLibrary = preload("res://MyUtilityLib.gd")
var targets_in_range = []
var ownerTeamID = 0
var blacklist: Array

func _on_body_entered(body):
	var hasTeam = body.get("team")
	if !blacklist.has(body.get_instance_id()) && hasTeam && body.team != ownerTeamID && body.team != 0:
		targets_in_range.push_back(body)
		print("A new target arrived on sight: " + body.name + " " + body.get_parent().name + ", " + get_parent().get_parent().name)
func _on_body_exited(body):
	arrayLibrary.RemoveFromList(targets_in_range, body)
func _on_ready():
	blacklist.push_back(self.get_parent().get_instance_id())
func getFirstTarget():
	if targets_in_range.size() > 0:
		return targets_in_range[0]
	return
