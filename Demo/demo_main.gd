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
var timeline: Array[Time_Event] = Timeline_Manager.DEFAULT_TIMELINE
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
	Anomaly.lock()
	player.lock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/HealthDispaly.text = "Health: " + str(player.health)
	if Input.is_action_just_pressed("reset_room"):
		player.position = current_room.start_pos * current_room.scale.x
		_on_era_timer_timeout()
	if Input.is_action_just_pressed("Era0"):
		lock_and_clear()
		change_eras(0)
		fade_out()
	if Input.is_action_just_pressed("Era1"):
		lock_and_clear()
		change_eras(1)
		fade_out()
	if Input.is_action_just_pressed("Era2"):
		lock_and_clear()
		change_eras(2)
		fade_out()

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
	lock_and_clear()

func lock_and_clear () -> void:
	player.lock()
	Anomaly.lock()
	clear_projectiles()

func _on_fade_in_full_fade() -> void:
	random_era()
	fade_out()

func fade_out () -> void:
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

# This thing does a lot more
func clear_unused_rooms () -> void:
	for i in range(rooms.size() - 1, -1, -1):
		if i != current_room_index:
			rooms[i].queue_free()
		else:
			current_room = rooms[i]
			if room_changed:
				player.position = current_room.start_pos * current_room.scale
			if current_room_index == 0:
				sal.show()
			else:
				sal.hide()

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
	player.lock()
	Anomaly.lock()
	FadeOut.set_label_text("You Win!")
	FadeOut.time_to_full = 100000
	FadeOut.show()
	print("Win!")


func _on_start_screen_pressed() -> void:
	player.unlock()
	Anomaly.unlock()
	$start_screen.queue_free()
