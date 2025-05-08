extends Node

class_name Time_Event

var layer_ids: PackedInt64Array
#True if we should only run each event if the previous event worked, false if we should run each independently
var is_dependent: bool
var effects: Array[Map_Change]
var time_to_happen: int


func _init (layer_ids: PackedInt64Array, effects: Array[Map_Change], is_dependent: bool, time_to_happen: int) :
	self.layer_ids = layer_ids
	self.effects = effects
	self.is_dependent = is_dependent
	self.time_to_happen = time_to_happen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func new_move (layer_id: int, remove_pos: Vector2i, add_pos: Vector2i, tile_type: Vector2i, time_to_happen: int) -> Time_Event:
	return new([layer_id], [Map_Change.new(layer_id, Map_Change.types.DELETE, remove_pos, tile_type), 
				Map_Change.new(layer_id, Map_Change.types.ADD, add_pos, tile_type)], 
				true, time_to_happen)
