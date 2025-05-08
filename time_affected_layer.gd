extends TileMapLayer

class_name Time_Affected_Layer

#Each PackedVector2Array is a row
var original_setup: Array[PackedVector2Array]
@export var max_width: int = 100
@export var max_height: int = 50
@export var layer_id: int = -1

func _init() -> void:
	if layer_id < 0:
		layer_id = 1
	#Store the original setup
	for row in range(max_height):
		var tile_row: PackedVector2Array = []
		for col in range(max_width):
			tile_row.append(get_cell_atlas_coords(Vector2i(col, row)))
		original_setup.append(tile_row)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_to_original ()-> void:
	for row in range(original_setup.size()):
		for col in range(original_setup[row].size()) :
			set_cell(Vector2i(col, row), 0, original_setup[row][col])
