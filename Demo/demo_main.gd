extends Node2D

@onready var FadeIn = $HUD/FadeIn
@onready var FadeOut = $HUD/FadeOut
@onready var EraTimer = $HUD/EraTimer
@onready var Anomaly = $Anomaly
@onready var player: Player = $CharacterBody2D
@onready var camera = $CharacterBody2D/Camera2D
@onready var sal: Sal = $Sal
var sal_pos = Vector2(480,96) * 2 # * 2 because scaling in tilemaplayers

@onready var timeline_manager: Timeline_Manager = $TimelineManager
var room_scenes: Array = [
	preload("res://hallway.tscn"),
	preload("res://tower.tscn")
]
var rooms: Array[Room] = [
	
]
var current_room_index = 0
var current_room: Room
var room_changed: bool = false
const HALLWAY_INTERACTABLES = "hallway_doors_and_such"
const ANY_TILE = Vector2i(-1,-1)
const LADDER_TOP = Vector2i(0,43)
const LADDER_MIDDLE = Vector2i(0,44)
const LADDER_BOTTOM = Vector2i(0,45)
var timeline: Array[Time_Event] = [
	################## Hallway stuff
	# Platform is always there
	# Ladder shows up in era 1
	# Door goes away in era 1
	
	# Remove door in era 1
	Time_Event.new_rect(HALLWAY_INTERACTABLES, Map_Change.types.DELETE, 
						Vector2i(29,-4), Vector2i(30,-2), 
						ANY_TILE, false, 1),
	# Remove ladder at start
	Time_Event.new_rect(HALLWAY_INTERACTABLES, Map_Change.types.DELETE, 
						Vector2i(32,-2), Vector2i(32,8), 
						ANY_TILE, false, 0),
	# Add ladder in era 1
	Time_Event.new_rect(HALLWAY_INTERACTABLES, Map_Change.types.ADD,
						Vector2i(32,-1), Vector2i(32,7),
						LADDER_MIDDLE, false, 1),
	Time_Event.new([
		Map_Change.new(HALLWAY_INTERACTABLES, Map_Change.types.ADD, Vector2i(32,-2), LADDER_TOP),
		Map_Change.new(HALLWAY_INTERACTABLES, Map_Change.types.ADD, Vector2i(32,8), LADDER_BOTTOM),
	], false, 1)
	################## Tower stuff
]
var max_eras = 3 # exclusive of this number, inclusive of 0, so eras 0, 1, and 2
const PLATFORM_TILE = Vector2i(0,1)
@export var anomaly_base_hp = 100
@export var player_base_hp = 100
signal win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline_manager.construct(timeline, 0)
	change_eras(0)
	Anomaly.player = player
	sal.pc = player
	sal.position = sal_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/HealthDispaly.text = "Health: " + str(player.health)
	if Input.is_action_just_pressed("reset_room"):
		player.position = current_room.start_pos
		_on_era_timer_timeout()

func random_era () -> void:
	change_eras(randi_range(0, max_eras - 1))
	room_changed = false

func change_eras (era: int) -> void:
	update_rooms()
	update_timeline_manager()
	timeline_manager.go_to_era(era)
	clear_unused_rooms() #also sets current room
	player.interactable_terrain = get_first_interactable_layer(current_room)
	set_camera_limits()
	set_anomaly_limits()
	Anomaly.hp = randi_range(0,anomaly_base_hp)
	Anomaly.show()
	sal.set_sal(era)

func _on_era_timer_timeout() -> void:
	FadeIn.reset_fade()
	FadeIn.show()
	player.lock()
	Anomaly.lock()
	clear_projectiles()


func _on_fade_in_full_fade() -> void:
	random_era()
	FadeOut.reset_fade()
	FadeOut.set_label_text("Era " + str($TimelineManager.current_era))
	FadeOut.show()
	FadeIn.hide()
	EraTimer.reset_current_time()


func _on_fade_out_full_fade() -> void:
	FadeOut.hide()
	player.unlock()
	Anomaly.unlock()

func clear_projectiles () -> void:
	for child in get_children():
		if child is Projectile:
			child.queue_free()

func get_time_affected_layers (room: Room) -> Array[Time_Affected_Layer]:
	var to_return: Array[Time_Affected_Layer] = []
	for child in room.get_children():
		if child is Time_Affected_Layer:
			to_return.append(child)
	return to_return

func update_rooms () -> void:
	for room in rooms:
		if room != null:
			room.queue_free()
	rooms = []
	for scene in room_scenes:
		var room = scene.instantiate()
		rooms.append(room)
		add_child(room)

func update_timeline_manager () -> void:
	timeline_manager.layers = []
	for room in rooms:
		timeline_manager.add_layers(get_time_affected_layers(room))

func clear_unused_rooms () -> void:
	for i in range(rooms.size() - 1, -1, -1):
		if i != current_room_index:
			rooms[i].queue_free()
		else:
			current_room = rooms[i]
			if room_changed:
				player.position = current_room.start_pos * current_room.scale
			if current_room_index == 0:
				current_room.add_child(sal)

func get_first_interactable_layer (room: Room) -> Time_Affected_Layer:
	for layer in get_time_affected_layers(room):
		if layer.is_interactable:
			return layer
	print("No interactable layers")
	return null

func set_camera_limits () -> void:
	camera.limit_left = current_room.left_limit * current_room.scale.x
	camera.limit_right = current_room.right_limit * current_room.scale.x
	camera.limit_bottom = current_room.bottom_limit * current_room.scale.x
	camera.limit_top = current_room.top_limit * current_room.scale.x

func set_anomaly_limits () -> void:
	Anomaly.high_limit = current_room.top_limit * current_room.scale.x
	Anomaly.low_limit = current_room.bottom_limit * current_room.scale.x
	Anomaly.left_limit = current_room.left_limit * current_room.scale.x
	Anomaly.right_limit = current_room.right_limit * current_room.scale.x

func _on_character_body_2d_door(door_id: int) -> void:
	if door_id < room_scenes.size():
		current_room_index = door_id
		room_changed = true
		_on_era_timer_timeout()
	else:
		win.emit()


func _on_character_body_2d_die() -> void:
	current_room_index = 0
	room_changed = true
	player.health = player_base_hp
	_on_era_timer_timeout()


func _on_anomaly_hit() -> void:
	EraTimer.decrease_max_time()


func _on_anomaly_die() -> void:
	EraTimer.reset_max_time()
	Anomaly.lock()
	Anomaly.position = Vector2(current_room.left_limit - 100, current_room.top_limit - 100)
	Anomaly.hide()


func _on_win() -> void:
	print("Win!")
