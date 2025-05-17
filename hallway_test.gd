extends Node2D

var rooms: Array[Room]
var timeline_manager:Timeline_Manager
var timeline: Array[Time_Event]
var max_eras = 11 # exclusive of this number
const PLATFORM_TILE = Vector2i(0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline_manager = $TimelineManager
	rooms = [
		$hallway
	]
	timeline = [
		# add red at time 1
		Time_Event.new([
			Map_Change.new("Room1Platforms", Map_Change.types.ADD, Vector2i(2,9), PLATFORM_TILE),
			Map_Change.new("Room1Platforms", Map_Change.types.ADD, Vector2i(2,13), PLATFORM_TILE),
		], false, 1),
		# remove red at time 5
		Time_Event.new([
			Map_Change.new("Room1Platforms", Map_Change.types.DELETE, Vector2i(2,9), PLATFORM_TILE),
			Map_Change.new("Room1Platforms", Map_Change.types.DELETE, Vector2i(2,13), PLATFORM_TILE),
		], false, 5),
		# add blue at time 3
		Time_Event.new_rect("Room1Platforms", Map_Change.types.ADD, Vector2i(10, 6), Vector2i(20,6), 
			PLATFORM_TILE, false, 3),
		# remove blue at time 6
		Time_Event.new_rect("Room1Platforms", Map_Change.types.DELETE, Vector2i(10, 6), Vector2i(20,6), 
			PLATFORM_TILE, false, 6),
		# add yellow at time 7
		Time_Event.new([
			Map_Change.new("Room1Platforms", Map_Change.types.ADD, Vector2i(7,7), PLATFORM_TILE),
			Map_Change.new("Room1Platforms", Map_Change.types.ADD, Vector2i(9,5), PLATFORM_TILE),
		], false, 7),
		# remove yellow at time 9
		Time_Event.new([
			Map_Change.new("Room1Platforms", Map_Change.types.DELETE, Vector2i(7,7), PLATFORM_TILE),
			Map_Change.new("Room1Platforms", Map_Change.types.DELETE, Vector2i(9,5), PLATFORM_TILE),
		], false, 9),
		# add goal at time 10
		Time_Event.new([
			Map_Change.new("Room1InteractableTerrain", Map_Change.types.ADD, Vector2i(34,14), Vector2i(3,3)),
		], false, 10),
	]
	timeline_manager.construct(timeline, 0)
	for room in rooms:
		room._ready()
		timeline_manager.add_layers(room.time_affected_layers)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("arbitrary_era"):
		timeline_manager.go_to_era(randi_range(0, max_eras))
	if event.is_action_pressed("Next_Era"):
		#print(timeline_manager.current_era)
		timeline_manager.go_to_era(timeline_manager.current_era + 1)
