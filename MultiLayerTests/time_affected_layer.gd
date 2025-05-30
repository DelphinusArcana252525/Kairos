extends TileMapLayer

class_name Time_Affected_Layer

#Each PackedVector2Array is a row
var original_setup: Array[PackedVector2Array]
#@export var max_width: int = 100
#@export var max_height: int = 50
@export var max_left = 0
@export var max_right = 0
@export var max_top = 0
@export var max_bottom = 0
@export var layer_id: String = ""
var source_id = 0 #TODO: be able to have different source ids
@export var is_interactable: bool
const ANY_TILE = Vector2i(-1,-1)

func _init() -> void:
	if layer_id == "":
		layer_id = "Default Layer Name"
	#Store the original setup
	for row in range(max_top, max_bottom + 1):
		var tile_row: PackedVector2Array = []
		for col in range(max_left, max_right + 1):
			var tile_at_pos = get_cell_atlas_coords(Vector2i(col, row))
			tile_row.append(tile_at_pos)
			if tile_at_pos != ANY_TILE:
				pass
				#print(tile_at_pos)
		original_setup.append(tile_row)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#TODO: be able to have different source ids
func apply_change (change: Map_Change) -> bool:
	if change.layer_id != layer_id:
		print("Wrong layer")
		print(change)
		print("Right layer: " + str(layer_id))
		return false
	match change.type:
		Map_Change.types.DELETE:
			if get_cell_atlas_coords(change.pos) == change.tile_type or change.tile_type == ANY_TILE:
				erase_cell(change.pos)
				return true
			return false
		Map_Change.types.ADD:
			set_cell(change.pos, source_id, change.tile_type)
			return true
	return false

func reset_to_original ()-> void:
	for row in range(original_setup.size()):
		for col in range(original_setup[row].size()) :
			set_cell(Vector2i(col, row), source_id, original_setup[row][col])
