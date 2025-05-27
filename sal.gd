extends Area2D

class_name Sal

#eras 0, 1, 2
var sprites = ["res://Assets/Kid_Sal.png", "res://Assets/Adult_Sal.png", "res://Assets/Dead_Sal.png"]

var dialogue_0 = ["Hey there! I'm Sal, who're you?", "You new 'round here?", "Alright, see you around!"]
var dialogue_1 = ["My goodness, it's you!", "I knew I didn't make you up. But man, you haven't aged a day!", "I'm Sal...don't you rememeber me?"]
var dialogue_2 = ["It's the sekeleton of an overzealous explorer.", "I wonder who they used to be..."]

var curr_dialogue
var dialogue_index
var curr_sprite
var pc: Player = Player.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_sal(0)
	print(curr_dialogue[dialogue_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#checks if the player is near sal
	#var pc = $character_body_2d/center.position
	
	if(abs(pc.position.x - self.position.x) < 50 and abs(pc.position.y - self.position.y) < 50):
		$dialog_box.show()
		#sal yaps to the player
		if(Input.is_action_just_pressed("talk")):
			$dialog_box.updateMessage("Sal", curr_dialogue[dialogue_index])
			if (dialogue_index < len(curr_dialogue) - 1):
				dialogue_index += 1
	else:
		$dialog_box.hide()

func set_sal(era):
	if(era == 0):
		curr_dialogue = dialogue_0
	if(era == 1):
		curr_dialogue = dialogue_1
	if(era == 2):
		curr_dialogue = dialogue_2
	
	curr_sprite = load(sprites[era])
	print(curr_sprite)
	$sal_sprite.texture = curr_sprite
	dialogue_index = 0
