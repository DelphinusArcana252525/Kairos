extends Node

class_name Time_Event

#True if we should only run each event if the previous event worked, false if we should run each independently
var is_dependent: bool #TODO: test dependent events
var effects: Array[Map_Change]
var time_to_happen: int


func _init (effects: Array[Map_Change], is_dependent: bool, time_to_happen: int) :
	self.effects = effects
	self.is_dependent = is_dependent
	self.time_to_happen = time_to_happen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func new_move (layer_id: String, remove_pos: Vector2i, add_pos: Vector2i, tile_type: Vector2i, time_to_happen: int) -> Time_Event:
	return new([Map_Change.new(layer_id, Map_Change.types.DELETE, remove_pos, tile_type), 
				Map_Change.new(layer_id, Map_Change.types.ADD, add_pos, tile_type)], 
				true, time_to_happen)

static func new_rect (layer_id: String, type: Map_Change.types, start_pos: Vector2i, end_pos: Vector2i, 
	tile_type: Vector2i, is_dependent: bool, time_to_happen: int) -> Time_Event:
	var effects: Array[Map_Change] = []
	for row in range (start_pos.y, end_pos.y + 1) : # +1 for inclusive
		for col in range (start_pos.x, end_pos.x + 1) : # +1 for inclusive
			effects.append(Map_Change.new(layer_id, type, Vector2i(col, row), tile_type))
	return Time_Event.new(effects, is_dependent, time_to_happen)

const PLATFORM_LEFT = Vector2i(10,46)
const PLATFORM_CENTER = Vector2i(11,46)
const PLATFORM_RIGHT = Vector2(12,46)

static func new_three_platform_add (center_pos: Vector2i, layer_id: String, time_to_happen: int) -> Time_Event:
	return Time_Event.new([
		Map_Change.new(layer_id, Map_Change.types.ADD, center_pos - Vector2i(1,0), PLATFORM_LEFT),
		Map_Change.new(layer_id, Map_Change.types.ADD, center_pos, PLATFORM_CENTER),
		Map_Change.new(layer_id, Map_Change.types.ADD, center_pos + Vector2i(1,0), PLATFORM_RIGHT),
	], false, time_to_happen)

func _to_string() -> String:
	return "Event at era " + str(time_to_happen) + " that does " + str(effects)
