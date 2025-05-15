extends Node

class_name Map_Change

enum types {DELETE, ADD}

const NO_INDEX = Vector2i(-1,-1)

var layer_id: String
var type: types
var pos: Vector2i
var tile_type: Vector2i

# when moving, first_pos is add_pos and second_pos is remove_pos. When adding/deleting, only use first_pos
func _init(layer_id: String, type: types, pos: Vector2i, tile_type: Vector2i = NO_INDEX) -> void:
	self.layer_id = layer_id
	self.type = type
	self.tile_type = tile_type
	self.pos = pos

func _to_string() -> String:
	return "Map_Change( layer: " + layer_id + ", type: " + str(type) + ", pos: " + str(pos) + ", tile_type: " + str(tile_type) + " )"
