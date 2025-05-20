extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_eras () -> void:
	print("Changing era")

func _on_era_timer_timeout() -> void:
	$FadeIn.reset_fade()
	$FadeIn.show()


func _on_fade_in_full_fade() -> void:
	change_eras()
	$FadeOut.reset_fade()
	$FadeOut.set_label_text("Era" + str($TimelineManager.current_era))
	$FadeOut.show()
	$FadeIn.hide()
	$EraTimer.reset_current_time()


func _on_fade_out_full_fade() -> void:
	$FadeOut.hide()
