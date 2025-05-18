extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var health: float = 100
var proj_scene = preload("res://Combat/Projectile.tscn")
@onready var center_pos = $Center.position
@export var proj_distance: float = 30
@export var proj_v: float = 200
@export var proj_dmg: float = 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("launch_projectile"):
		fire_projectile()

func take_damage (damage: float) -> void:
	health -= damage
	print("New health: " + str(health))

func fire_projectile () -> void:
	var proj = proj_scene.instantiate()
	var angle = atan2(get_global_mouse_position().y - get_global_transform().origin.y, 
		get_global_mouse_position().x - get_global_transform().origin.x)
	atan2(0,1) # is in radians
	# get the right angle
	var direction = Vector2(cos(angle), sin(angle))
	# make it not hit itself
	var start_pos = position + center_pos + proj_distance * direction
	proj.position = start_pos
	# point in the right direction
	proj.velocity = proj_v * direction
	# make the right damage
	proj.damage = proj_dmg
	get_parent().add_child(proj)
