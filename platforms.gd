extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_change (change: Map_Change) -> bool:
	match change.type:
		Map_Change.types.DELETE:
			if get_cell_atlas_coords(change.remove_pos) == change.tile_type:
				erase_cell(change.remove_pos)
				return true
			return false
		Map_Change.types.ADD:
			set_cell(change.add_pos, 0, change.tile_type)
			return true
	return false

func delete_from_move (move: Map_Change) -> Map_Change:
	return Map_Change.new(Map_Change.types.DELETE, move.remove_pos, move.tile_type)
