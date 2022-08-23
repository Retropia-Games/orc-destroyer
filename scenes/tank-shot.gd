extends Area2D

export var MOVE_SPEED = 100

func _process(delta):
	self.position -= Vector2(MOVE_SPEED * delta, 0.0);
	
	if position.x <= 0 - 8:
		queue_free()

func _on_tank_shot_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
