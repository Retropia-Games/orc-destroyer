extends Area2D

export var MOVE_SPEED = 400
var stage = load("res://scenes/stage.gd")

func _process(delta):
	self.position -= Vector2(MOVE_SPEED * delta, 0.0);
	if position.x <= 0:
		queue_free()

func _on_enemy_bullet_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
