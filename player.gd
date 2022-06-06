extends Area2D


var explosion_scene = preload("res://explosion.tscn")

export var MOVE_SPEED = 150.0
var stage = load("res://stage.gd")
var shot_scene = preload("res://javelin.tscn")
var can_shoot = true

signal destroyed

func _process(delta):
	var input_dir = Vector2()
	
	# Up & down movement
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
		
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
		
	position += (delta * MOVE_SPEED) * input_dir
	
	# Limit movement in Y axis
	if position.y < 0.0:
		position.y = 0.0
	elif position.y > stage.SCREEN_HEIGHT:
		position.y = stage.SCREEN_HEIGHT

	# Shoting
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		can_shoot = false
		
		var stage_node = get_parent()
		
		var shot_instance = shot_scene.instance()
		shot_instance.position = position + Vector2(20, 0)
		stage_node.add_child(shot_instance)


func _on_reload_timer_timeout():
	can_shoot = true

func _on_player_area_entered(area):
	if area.is_in_group("enemy"):
		emit_signal("destroyed")
		queue_free()
		
		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)
