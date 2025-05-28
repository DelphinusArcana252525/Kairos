extends Node2D

class_name Timeline_Manager

var timeline: Array[Time_Event]
var layers: Array[Time_Affected_Layer]
var current_era: int
const HALLWAY_INTERACTABLES = "hallway_doors_and_such"
const TOWER_PLATFORMS = "tower_platforms"
const ANY_TILE = Vector2i(-1,-1)
const LADDER_TOP = Vector2i(0,43)
const LADDER_MIDDLE = Vector2i(0,44)
const LADDER_BOTTOM = Vector2i(0,45)
const WALL = Vector2i(1,3)
const PLATFORM_LEFT = Vector2i(10,46)
const PLATFORM_CENTER = Vector2i(11,46)
const PLATFORM_RIGHT = Vector2(12,46)
static var DEFAULT_TIMELINE: Array[Time_Event] = [
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
	], false, 1),
	################## Tower stuff
	# Red is era 0, yellow is era 1, blue is era 2, and white is all eras.
	
	### Remove everything that isn't in era 0
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(13,24), Vector2i(18,24),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(8,21), Vector2i(9,21),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(17,20), Vector2i(17,20),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(12, 18), Vector2i(14, 18),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(19,18), Vector2i(20,18),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(20,8), Vector2i(22,8),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(14,3), Vector2i(16,3),
						ANY_TILE, false, 0),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(19,2), Vector2i(22,2),
						ANY_TILE, false, 0),
	### Remove everything that gets removed in era 1
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(17,14), Vector2i(19,14),
						ANY_TILE, false, 1),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(23,12), Vector2i(25,12),
						ANY_TILE, false, 1),
	### Add everything from era 1
	Time_Event.new_three_platform_add(Vector2i(14,24), TOWER_PLATFORMS, 1),
	Time_Event.new_three_platform_add(Vector2i(17,24), TOWER_PLATFORMS, 1),
	Time_Event.new_three_platform_add(Vector2i(13,18), TOWER_PLATFORMS, 1),
	Time_Event.new_three_platform_add(Vector2i(19,18), TOWER_PLATFORMS, 1),
	Time_Event.new_three_platform_add(Vector2i(15,3), TOWER_PLATFORMS, 1),
	Time_Event.new_three_platform_add(Vector2i(8,21), TOWER_PLATFORMS, 1),
	Time_Event.new([Map_Change.new(TOWER_PLATFORMS, Map_Change.types.ADD, Vector2i(7,21), WALL)], false, 1),
	### Remove everything from era 2
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(23,22), Vector2i(25,22),
						ANY_TILE, false, 2),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(8,21), Vector2i(9,21),
						ANY_TILE, false, 2),
	Time_Event.new_rect(TOWER_PLATFORMS, Map_Change.types.DELETE,
						Vector2i(14,3), Vector2i(16,3),
						ANY_TILE, false, 2),
	### Add everything from era 2
	# Easy plaforms
	Time_Event.new_three_platform_add(Vector2i(24,12), TOWER_PLATFORMS, 2),
	Time_Event.new_three_platform_add(Vector2i(21,8), TOWER_PLATFORMS, 2),
	Time_Event.new_three_platform_add(Vector2i(21,2), TOWER_PLATFORMS, 2),
	# Annoying platforms
	Time_Event.new([Map_Change.new(TOWER_PLATFORMS, Map_Change.types.ADD, Vector2i(17,20), PLATFORM_LEFT)], false, 2),
	Time_Event.new([Map_Change.new(TOWER_PLATFORMS, Map_Change.types.ADD, Vector2i(19,2), PLATFORM_LEFT)], false, 2),
	# Door
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func construct (timeline: Array[Time_Event], start_era: int = 0):
	self.timeline = timeline
	self.layers = []
	current_era = start_era

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_event (event: Time_Event) -> void:
	for change in event.effects:
		for layer in layers:
			var happened: bool = false
			if layer.layer_id == change.layer_id:
				if layer.apply_change(change):
					happened = true
			if event.is_dependent and not happened:
				return


func add_layers(new_layers: Array[Time_Affected_Layer]) -> bool:
	for new_layer in new_layers:
		for old_layer in layers:
			if old_layer.layer_id == new_layer.layer_id:
				print("Conflict: Layers have the same id")
				print(old_layer)
				print(new_layer)
				return false
		layers.append(new_layer)
	return true


func go_to_era (new_era: int) -> void:
	print("New era: " + str(new_era))
	for layer in layers:
		layer.reset_to_original()
	var era = 0
	while era <= new_era:
		for event in timeline:
			if event.time_to_happen == era:
				apply_event(event)
		era += 1
	current_era = new_era
