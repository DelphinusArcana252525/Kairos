extends Node2D

@export var time_to_full = 2
const BLACK = Color(0,0,0)
const WHITE = Color(1,1,1)
var time_elapsed = 0
@export var fade_out = false
var emitted = true
signal full_fade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = Color(BLACK, 0)

func reset_fade () -> void:
	emitted = false
	time_elapsed = 0
	if fade_out:
		$ColorRect.color = Color(BLACK, 1)
		$EraLabel.modulate = Color(WHITE, 1)
	else:
		$ColorRect.color = Color(BLACK, 0)
		$EraLabel.modulate = Color(WHITE, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	if fade_out:
		var fade = (time_to_full - time_elapsed) / time_to_full
		$ColorRect.color = Color(BLACK, fade)
		$EraLabel.modulate = Color(WHITE, fade)
	else:
		var fade = time_elapsed / time_to_full
		$ColorRect.color = Color(BLACK, fade)
		$EraLabel.modulate = Color(WHITE, fade)
	if time_elapsed >= time_to_full and not emitted:
		emitted = true
		full_fade.emit()

func set_label_text (text: String) -> void:
	$EraLabel.text = text
