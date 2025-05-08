extends Node2D

var timeline: Array[Time_Event]
var layers: Array[Time_Affected_Layer]
var era: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline = []
	layers = []
	era = 0


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
