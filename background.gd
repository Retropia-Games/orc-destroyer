extends Sprite
var scroll_speed = 30.0
var stage = load("res://stage.gd")

func _process(delta):
	position += Vector2(-scroll_speed * delta, 0.0)
	
	if position.x <= -stage.SCREEN_WIDTH:
		position.x += stage.SCREEN_WIDTH
