extends Node

class_name Map_Change

enum types {DELETE, ADD, MOVE}

const NO_INDEX = Vector2i(-1,-1)

var type: types
var add_pos: Vector2i
var remove_pos: Vector2i
var tile_type: Vector2i

# when moving, first_pos is add_pos and second_pos is remove_pos. When adding/deleting, only use first_pos
func _init(type: types, first_pos: Vector2i = NO_INDEX, tile_type: Vector2i = NO_INDEX, second_pos: Vector2i = NO_INDEX) -> void:
	self.type = type
	self.tile_type = tile_type
	match type :
		types.DELETE: 
			add_pos = NO_INDEX
			remove_pos = first_pos
		types.ADD:
			add_pos = first_pos
			remove_pos = NO_INDEX
		types.MOVE:
			add_pos = first_pos
			remove_pos = second_pos
