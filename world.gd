extends Node2D

var timeline: Array[Time_Event]
var era: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline = [
		Time_Event.new([ # add the red platform
			Map_Change.new(Map_Change.types.ADD, Vector2i(6,15), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.ADD, Vector2i(7,15), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.ADD, Vector2i(8,15), Vector2i(0,1))
		], false, 1),
		Time_Event.new([ # remove the red platform
			Map_Change.new(Map_Change.types.DELETE, Vector2i(6,15), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(7,15), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(8,15), Vector2i(0,1))
		], false, 5),
		Time_Event.new([ # remove the blue platforms
			Map_Change.new(Map_Change.types.DELETE, Vector2i(17,10), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(17,11), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(17,12), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(17,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(18,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(19,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(20,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(21,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(28,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(29,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(30,13), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.DELETE, Vector2i(31,13), Vector2i(0,1))
		], false, 7),
		Time_Event.new([ # add the yellow platforms
			Map_Change.new(Map_Change.types.ADD, Vector2i(14,11), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.ADD, Vector2i(15,11), Vector2i(0,1)),
			Map_Change.new(Map_Change.types.ADD, Vector2i(17,9), Vector2i(0,1))
		], false, 7)
	]
	#timeline = [Time_Event.new([Map_Change.new(Map_Change.types.ADD, Vector2i(1,1), Vector2i(0,1))], false, 1),
	#			Time_Event.new([Map_Change.new(Map_Change.types.ADD, Vector2i(1,2), Vector2i(0,1))], false, 5),
	#			Time_Event.new([Map_Change.new(Map_Change.types.DELETE, Vector2i(7,12), Vector2i(0,1))], false, 3)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("arbitrary_era"):
		go_to_era(randi_range(0, 10))
	if event.is_action_pressed("Next_Era"):
		go_to_era(era + 1)
	if event.is_action_pressed("reset"):
		era = 0
		print("reset")
		$Platforms.reset_to_original()


func go_to_era (era: int) -> void:
	$Platforms.reset_to_original()
	self.era = era
	print("era " + str(era))
	for time in range(era + 1): # +1 so it's inclusive
			for time_event in timeline:
				if time_event.time_to_happen == time:
					$Platforms.apply_time_event(time_event)
