extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var phase = 0

@export var hp : int

#rewrite this so he doesnt move via keyboard
#make him move randomly for now
func _physics_process(delta: float) -> void:
	
	pass

	move_and_slide()
	
func take_damage(dmg) -> void:
	hp -= dmg
	print("Anomaly health: " + str(hp))
