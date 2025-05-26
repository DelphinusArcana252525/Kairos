extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const LADDER_SPEED = 200.0
@export var health: float = 100
var proj_scene = preload("res://Combat/Projectile.tscn")
@onready var center_pos = $Center.position
@export var proj_distance: float = 30
@export var proj_v: float = 200
@export var proj_dmg: float = 10
var interactable_terrain: Time_Affected_Layer
const LADDERS = [Vector2i(0,43), Vector2i(0,44), Vector2i(0,45)]
signal hit
signal die

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not (is_on_floor() or is_on_ladder()):
		velocity += get_gravity() * delta
	
	if is_on_ladder():
		if Input.is_action_pressed("jump"):
			velocity.y = -LADDER_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = LADDER_SPEED
		else:
			velocity.y = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("launch_projectile"):
		fire_projectile()
	print(is_on_ladder())

func take_damage (damage: float, proj_launcher: String) -> bool:
	health -= damage
	print("New health: " + str(health))
	hit.emit()
	if health <= 0:
		die.emit()
	return true

func fire_projectile () -> void:
	var proj = proj_scene.instantiate()
	var angle = atan2(get_global_mouse_position().y - get_global_transform().origin.y, 
		get_global_mouse_position().x - get_global_transform().origin.x)
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

func is_on_ladder() -> bool:
	var map_coords = interactable_terrain.local_to_map(interactable_terrain.to_local(get_global_transform().origin))
	var tile_type = interactable_terrain.get_cell_atlas_coords(map_coords)
	return tile_type in LADDERS
