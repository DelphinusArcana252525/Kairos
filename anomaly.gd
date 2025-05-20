extends StaticBody2D


var speed = 200
const JUMP_VELOCITY = -400.0
var direct_vect
var phase = 0
var is_hostile : bool = false
var goal_pos : Vector2 = Vector2(0,0)
var proj_scene = preload("res://Combat/Projectile.tscn")

@export var hp : int

#rewrite this so he doesnt move via keyboard
#make him move randomly for now
func _physics_process(delta: float) -> void:
	if(is_goal_met(goal_pos) or goal_pos == Vector2(0,0)):
		move_random()
		fire_projectile()
		print("changed goal")
	self.position += direct_vect * speed * delta
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
		speed = 400

	
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
	
	
func fire_projectile () -> void:
	var proj = proj_scene.instantiate()
	var proj_v = 500

	
	var direction = Vector2(1,1)
	proj.position = self.position + 50*direction
	#direction = #get character position - self.position
	#direction *= 1/(len(direction)) 
	#proj.velocity = proj_v * direction
	# make the right damage
	proj.damage = 15
	proj.velocity = direction * proj_v
	get_parent().add_child(proj)
	print("projectile fired")
