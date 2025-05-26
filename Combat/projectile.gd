extends Area2D

@export var velocity: Vector2
@export var damage: float
@export var launcher: String = "default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("take_damage"):
		if body.take_damage(damage, launcher):
			queue_free()
	else:
		queue_free()
