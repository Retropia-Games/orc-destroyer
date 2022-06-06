extends Area2D

var explosion_scene = preload("res://explosion.tscn")

export var MOVE_SPEED = 100.0
var score_emitted = false

signal score

func _process(delta):
	position -= Vector2(MOVE_SPEED * delta, 0.0);
	
	if position.x <= -100:
		queue_free()


func _on_enemy_tank_area_entered(area):
	if area.is_in_group("shot"):
		if not  score_emitted:
			score_emitted = true
			emit_signal("score")
			queue_free()
			
			var stage_node = get_parent()
			var explosion_instance = explosion_scene.instance()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)
