extends Area2D

#eras 0, 1, 2
var sprites = ["res://assets/Kid_Sal.png", "res://assets/Adult_Sal.png", "res://assets/Dead_Sal.png"]

var dialogue_0 = ["Hey there! I'm Sal, who're you?", "You new 'round here?", "Alright, see you around!"]
var dialogue_1 = ["My goodness, it's you!", "I knew I didn't make you up. But man, you haven't aged a day!", "I'm Sal...don't you rememeber me?"]
var dialogue_2 = ["It's the sekeleton of an overzealous explorer.", "I wonder who they used to be..."]

var curr_dialogue
var dialogue_index
var curr_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_sal(2)
	print(curr_dialogue[dialogue_index])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#yap function (he speaking, dialogue index increases until reaches last dialogue

func set_sal(era):
	if(era == 0):
		curr_dialogue = dialogue_0
	if(era == 1):
		curr_dialogue = dialogue_1
	if(era == 2):
		curr_dialogue = dialogue_2
	
	curr_sprite = load(sprites[era])
	$sal_sprite.texture = curr_sprite
	dialogue_index = 0
		
