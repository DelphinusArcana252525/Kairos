extends Node2D


var changes: Array[Map_Change]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changes = [Map_Change.new(Map_Change.types.DELETE, Vector2i(5,8), Vector2i(0,1)), Map_Change.new(Map_Change.types.ADD, Vector2i(1,1))]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Next_Era"):
		print("hi")
		for change in changes:
			print($Platforms.apply_change(change))
