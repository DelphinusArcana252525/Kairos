extends Node2D

class_name Room

var time_affected_layers: Array[Time_Affected_Layer] = [
	
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for layer in time_affected_layers:
		layer._init()
		layer._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
