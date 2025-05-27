extends Node2D

@onready var FadeIn = $HUD/FadeIn
@onready var FadeOut = $HUD/FadeOut
@onready var EraTimer = $HUD/EraTimer
@onready var Anomaly = $Anomaly
@onready var player: Player = $CharacterBody2D
@onready var camera = $CharacterBody2D/Camera2D

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
@onready var timeline: Array[Time_Event] = [
	
]
var max_eras = 3 # exclusive of this number, inclusive of 0, so eras 0, 1, and 2
const PLATFORM_TILE = Vector2i(0,1)
@export var anomaly_base_hp = 100
@export var player_base_hp = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline_manager.construct(timeline, 0)
	change_eras(0)
	Anomaly.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Anomaly.position)
	pass

func random_era () -> void:
	change_eras(randi_range(0, max_eras - 1))
	room_changed = false

func change_eras (era: int) -> void:
	update_rooms()
	update_timeline_manager()
	timeline_manager.current_era = era
	clear_unused_rooms() #also sets current room
	player.interactable_terrain = get_first_interactable_layer(current_room)
	set_camera_limits()
	set_anomaly_limits()
	Anomaly.hp = randi_range(0,anomaly_base_hp)

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
	#print(get_children())
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
		#print(i)
		if i != current_room_index:
			rooms[i].queue_free()
		else:
			current_room = rooms[i]
			if room_changed:
				player.position = current_room.start_pos * current_room.scale

func get_first_interactable_layer (room: Room) -> Time_Affected_Layer:
	for layer in get_time_affected_layers(room):
		if layer.is_interactable:
			return layer
	print("No interactable layers")
	return null

func set_camera_limits () -> void:
	#print("Limits changed")
	#print(current_room_index)
	#print(current_room)
	camera.limit_left = current_room.left_limit * current_room.scale.x
	camera.limit_right = current_room.right_limit * current_room.scale.x
	camera.limit_bottom = current_room.bottom_limit * current_room.scale.x
	camera.limit_top = current_room.top_limit * current_room.scale.x

func set_anomaly_limits () -> void:
	Anomaly.high_limit = current_room.top_limit * current_room.scale.x
	Anomaly.low_limit = current_room.bottom_limit * current_room.scale.x
	Anomaly.left_limit = current_room.left_limit * current_room.scale.x
	Anomaly.right_limit = current_room.right_limit * current_room.scale.x

func _on_character_body_2d_door() -> void:
	current_room_index = 1
	room_changed = true
	_on_era_timer_timeout()


func _on_character_body_2d_die() -> void:
	current_room_index = 0
	room_changed = true
	player.health = player_base_hp
	_on_era_timer_timeout()


func _on_anomaly_hit() -> void:
	EraTimer.decrease_max_time()


func _on_anomaly_die() -> void:
	EraTimer.reset_max_time()
