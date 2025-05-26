extends StaticBody2D


@export var base_speed = 200
var speed = base_speed
@export var hostile_speed = 400
var direct_vect
var phase = 0
var is_hostile : bool = false
var goal_pos : Vector2 = Vector2(0,0)
var proj_scene = preload("res://Combat/Projectile.tscn")
var player: Player
@export var high_limit: int = 0
@export var low_limit: int = 648
@export var left_limit: int = 0
@export var right_limit: int = 1152

@export var hp : int

signal hit
signal die

#rewrite this so he doesnt move via keyboard
#make him move randomly for now
func _physics_process(delta: float) -> void:
	if(is_goal_met(goal_pos) or goal_pos == Vector2(0,0)):
		move_random()
		fire_projectile()
		print("changed goal")
	self.position += direct_vect * speed * delta

func _ready() -> void:
	move_random()
	
func take_damage(dmg, proj_launcher: String) -> bool:
	if proj_launcher != "Anomaly":
		hp -= dmg
		is_hostile = true
		hit.emit()
		if hp <= 0:
			die.emit()
		print("Anomaly health: " + str(hp))
		return true
	return false

func move_random() -> void:
	#var bounds = get_viewport().get_visible_rect().size
	#print(bounds)
	var x_pos = randi_range(left_limit, right_limit)
	var y_pos = randi_range(high_limit, low_limit)
	var goal = Vector2(x_pos, y_pos)
	get_direction(goal)
	goal_pos = goal
	if(is_hostile):
		speed = hostile_speed


func get_direction(goal) -> void:
	var direction : Vector2 = goal - self.position #?
	var len = direction.length()
	direction *= (1/len)
	direct_vect = direction
	#now we have a unit vector
	
func reset() -> void:
	goal_pos = Vector2(0,0)
	is_hostile = false
	speed = base_speed

func is_goal_met(goal) -> bool:
	return abs(self.position.x - goal.x) < 5 and abs(self.position.y - goal.y) < 5
	
	
func fire_projectile () -> void:
	var proj = proj_scene.instantiate()
	var proj_v = 500

	
	var direction = get_player_pos() - self.position
	direction *= 1/(direction.length())
	proj.velocity = proj_v * direction
	# make the right damage
	proj.position = self.position + 50*direction
	proj.damage = 15
	proj.velocity = direction * proj_v
	proj.launcher = "Anomaly"
	get_parent().add_child(proj)
	print("projectile fired")

func get_player_pos () -> Vector2:
	if player == null:
		print("Anomaly has no player")
		return Vector2(0,0)
	return player.position
