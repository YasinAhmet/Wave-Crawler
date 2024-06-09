extends Resource
class_name Attack 

@export var damage = 10
@export var animation = "AnimationName"

func Attack(attackDamage, attackAnimName):
	damage = attackDamage
	animation = attackAnimName
	return self
