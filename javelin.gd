extends Area2D

export var MOVE_SPEED = 500
var stage = load("res://stage.gd")

func _process(delta):
	self.position += Vector2(MOVE_SPEED * delta, 0.0);
	
	if position.x >= stage.SCREEN_WIDTH + 8:
		queue_free()


func _on_javelin_area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()
