extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -510.0
const JUMP_DISPLACEMENT = -5.0
const LADDER_SPEED = 200.0
@export var health: float = 100
var proj_scene = preload("res://Combat/Projectile.tscn")
@onready var center_pos = $Center.position
@export var proj_distance: float = 30
@export var proj_v: float = 200
@export var proj_dmg: float = 10
var interactable_terrain: Time_Affected_Layer
const LADDERS = [Vector2i(0,43), Vector2i(0,44), Vector2i(0,45)]
const DOORS = [Vector2i(0,31), Vector2i(0,32), Vector2i(0,33),
			   Vector2i(1,31), Vector2i(1,32), Vector2i(1,33),
			   Vector2i(0,28), Vector2i(0,29), Vector2i(0,30),
			   Vector2i(1,28), Vector2i(1,29), Vector2i(1,30),
			   Vector2i(2,31), Vector2i(2,32), Vector2i(2,33),
			   Vector2i(3,31), Vector2i(3,32), Vector2i(3,33)]
var is_locked = false
signal hit
signal die
signal door(door_id: int)

func _physics_process(delta: float) -> void:
	if not is_locked:
		#print(get_gravity())
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
			position.y += JUMP_DISPLACEMENT
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _process(delta: float) -> void:
	if not is_locked:
		if Input.is_action_just_pressed("launch_projectile"):
			fire_projectile()
		if Input.is_action_just_pressed("down") and is_on_door():
			door.emit(get_door_id())

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
	if interactable_terrain == null:
		return false
	var map_coords = interactable_terrain.local_to_map(interactable_terrain.to_local(get_global_transform().origin))
	var tile_type = interactable_terrain.get_cell_atlas_coords(map_coords)
	return tile_type in LADDERS

func is_on_door() -> bool:
	if interactable_terrain == null:
		return false
	var map_coords = interactable_terrain.local_to_map(interactable_terrain.to_local(get_global_transform().origin))
	var tile_type = interactable_terrain.get_cell_atlas_coords(map_coords)
	return tile_type in DOORS

func get_door_id () -> int:
	if interactable_terrain == null:
		return -1
	var map_coords = interactable_terrain.local_to_map(interactable_terrain.to_local(get_global_transform().origin))
	return interactable_terrain.get_cell_tile_data(map_coords).get_custom_data("Door_ID")

func lock () -> void:
	is_locked = true

func unlock () -> void:
	is_locked = false
