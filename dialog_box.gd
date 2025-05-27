extends CanvasLayer

var dialogueText
var nameText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogueText = $dialogue
	nameText = $name
	#updateMessage("Joe", "I like oats!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
#sets the name and the message
func updateMessage(name, dialogue):
	dialogueText.set_text(dialogue)
	nameText.set_text(name)
	
	
