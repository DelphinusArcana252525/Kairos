extends StaticBody2D


var speed = 2
const JUMP_VELOCITY = -400.0
var direct_vect
var phase = 0
var is_hostile : bool = false
var goal_pos : Vector2 = Vector2(0,0)

@export var hp : int

#rewrite this so he doesnt move via keyboard
#make him move randomly for now
func _physics_process(delta: float) -> void:
	if(is_goal_met(goal_pos) or goal_pos == Vector2(0,0)):
		move_random()
		print("changed goal")
	self.position += direct_vect * speed
	
	pass

func _ready() -> void:
	move_random()
	
func take_damage(dmg) -> void:
	hp -= dmg
	is_hostile = true
	print("Anomaly health: " + str(hp))
	
func move_random() -> void:
	var bounds = get_viewport().get_visible_rect().size
	#print(bounds)
	var x_pos = randi_range(0, 1152)
	var y_pos = randi_range(0,640)
	var goal = Vector2(x_pos, y_pos)
	get_direction(goal)
	goal_pos = goal
	if(is_hostile):
		speed = 5

	
func get_direction(goal) -> void:
	var direction : Vector2 = goal - self.position #?
	var len = direction.length()
	direction *= (1/len)
	direct_vect = direction
	#now we have a unit vector
	
func reset() -> void:
	goal_pos = Vector2(0,0)
	is_hostile = false
	speed = 2

func is_goal_met(goal) -> bool:
	return abs(self.position.x - goal.x) < 5 and abs(self.position.y - goal.y) < 5
	
