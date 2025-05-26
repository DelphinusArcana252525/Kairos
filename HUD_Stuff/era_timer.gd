extends Node2D

@export var max_max_time = 60
@export var change_coeff = 0.75
var time_elapsed = 0
var current_max_time = 60

signal timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_max_time()
	reset_current_time()
	update_label_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= current_max_time:
		timeout.emit()
		time_elapsed = 0
	update_label_text()
	

func update_label_text () -> void:
	var time_left = current_max_time - time_elapsed
	if (time_left < 10) :
		$Label.text = "00:0" + str(time_left).substr(0,1)
	elif (time_left < 60):
		$Label.text = "00:" + str(time_left).substr(0,2)
	elif (time_left < 600):
		var seconds = time_left % 60
		var minutes = time_left / 60
		if (seconds < 10):
			$Label.text = "0" + str(seconds).substr(0,1) + ":0" + str(seconds).substr(0,1)
		else:
			$Label.text = "0" + str(seconds).substr(0,1) + ":" + str(seconds).substr(0,2)
	else:
		var seconds = time_left % 60
		var minutes = time_left / 60
		if (seconds < 10):
			$Label.text = str(seconds).substr(0,2) + ":0" + str(seconds).substr(0,1)
		else:
			$Label.text = str(seconds).substr(0,2) + ":" + str(seconds).substr(0,2)

func decrease_max_time () -> void:
	current_max_time *= change_coeff

func reset_max_time () -> void:
	current_max_time = max_max_time

func reset_current_time () -> void:
	time_elapsed = 0
