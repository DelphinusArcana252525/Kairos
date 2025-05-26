extends Node2D

@onready var FadeIn = $HUD/FadeIn
@onready var FadeOut = $HUD/FadeOut
@onready var EraTimer = $HUD/EraTimer
@onready var Anomaly = $Anomaly
@onready var player = $CharacterBody2D

@onready var timeline_manager: Timeline_Manager = $TimelineManager
@onready var rooms: Array[Room] = [
	$hallway
]
@onready var timeline: Array[Time_Event] = [
	
]
var max_eras = 3 # exclusive of this number, inclusive of 0, so eras 0, 1, and 2
const PLATFORM_TILE = Vector2i(0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline_manager.construct(timeline, 0)
	for room in rooms:
		room._ready()
		timeline_manager.add_layers(room.time_affected_layers)
	Anomaly.player = player
	player.interactable_terrain = $hallway/doors_and_such
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_eras () -> void:
	print("Changing era")

func _on_era_timer_timeout() -> void:
	FadeIn.reset_fade()
	FadeIn.show()


func _on_fade_in_full_fade() -> void:
	change_eras()
	FadeOut.reset_fade()
	FadeOut.set_label_text("Era" + str($TimelineManager.current_era))
	FadeOut.show()
	FadeIn.hide()
	EraTimer.reset_current_time()


func _on_fade_out_full_fade() -> void:
	FadeOut.hide()
