extends TileMapLayer

#Each PackedVector2Array is a row
var original_setup: Array[PackedVector2Array]
@export var max_width: int = 100
@export var max_height: int = 50

func _init() -> void:
	for row in range(max_height):
		var tile_row: PackedVector2Array = []
		for col in range(max_width):
			tile_row.append(get_cell_atlas_coords(Vector2i(col, row)))
		original_setup.append(tile_row)
	for row in original_setup:
		for cell in row:
			if Vector2i(cell) != Vector2i(-1,-1):
				print(cell)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_time_event (event: Time_Event) -> void:
	if event.is_dependent:
		var effects = event.effects
		var i: int = 0
		while i < effects.size() and apply_change(effects[i]):
			i += 1
	else:
		for change in event.effects:
			apply_change(change)


func apply_change (change: Map_Change) -> bool:
	match change.type:
		Map_Change.types.DELETE:
			if get_cell_atlas_coords(change.pos) == change.tile_type:
				erase_cell(change.pos)
				return true
			return false
		Map_Change.types.ADD:
			set_cell(change.pos, 0, change.tile_type)
			return true
	return false

func reset_to_original ()-> void:
	print("reset platforms")
	for row in range(original_setup.size()):
		for col in range(original_setup[row].size()) :
			set_cell(Vector2i(col, row), 0, original_setup[row][col])
