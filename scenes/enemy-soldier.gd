extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	position -= Vector2(5 * delta, 0.0);
	
	if position.x <= -100:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
