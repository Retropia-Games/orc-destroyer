extends Area2D

var explosion_scene = preload("res://scenes/explosion.tscn")
var player_death_scene = preload("res://scenes/player-death.tscn")
var shot_scene = preload("res://scenes/javelin.tscn")
var bullet_scene = preload("res://scenes/bullet.tscn")
var casing_scene = preload("res://scenes/casing.tscn")
var rng = RandomNumberGenerator.new()

export var MOVE_SPEED = 150.0
export var RIFLE_RELOAD_TIME = 0.5
export var JAVELIN_RELOAD_TIME = 2
export var INVINCIBILITY_CYCLES = 12
var invincibility = 0
var stage = load("res://scenes/stage.gd")
var weapon = "rifle";
var can_shoot = true
var lives = 3

signal destroyed
signal change_weapon
signal loose_life

func _process(delta):
	var input_dir = Vector2()
	var walk = false
	
	# Up & down movement
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
		walk = true
	
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
		walk = true
		
	# Left & right movement
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
		walk = true
		
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
		walk = true
	
	if walk:
		$fella.play("walk")
	else:
		$fella.play("stand")
		
	position += (delta * MOVE_SPEED) * input_dir
	
	# Limit movement in Y axis
	if position.y < 0.0:
		position.y = 0.0
	elif position.y > stage.SCREEN_HEIGHT:
		position.y = stage.SCREEN_HEIGHT
		
	# Limit movement in X axis
	if position.x < 0.0:
		position.x = 0.0
	elif position.x > stage.SCREEN_WIDTH:
		position.x = stage.SCREEN_WIDTH

	# Shoting
	if Input.is_key_pressed(KEY_SPACE):
		if weapon == "rifle":
			$m4a1.play("shooting")
		
		if can_shoot:
			can_shoot = false
			if weapon == "javelin":
				shoot_javelin()
			elif weapon == "rifle":
				shoot_bullet()
	else:
		$m4a1.stop()
		$m4a1.frame = 0
			
func _input(event):
	# Change weapon
	if event.is_action_released("ui_focus_next") and weapon == "javelin":
		weapon = "rifle"
		emit_signal("change_weapon", weapon)
		$"reload_timer".stop()
		$"reload_timer".wait_time = RIFLE_RELOAD_TIME
		$"reload_timer".start()
		$javelin.visible=false
		$m4a1.visible=true
	elif event.is_action_released("ui_focus_next") and weapon == "rifle":
		weapon = "javelin"
		emit_signal("change_weapon", weapon)
		$"reload_timer".stop()
		$"reload_timer".wait_time = JAVELIN_RELOAD_TIME
		$"reload_timer".start()
		$javelin.visible=true
		$m4a1.visible=false
		
func shoot_javelin():
	var stage_node = get_parent()
	$smoke.restart()
	var shot_instance = shot_scene.instance()
	shot_instance.position = position + Vector2(20, 0)
	stage_node.add_child(shot_instance)
	
	$javelin.play("shooting")
	
	
func shoot_bullet():
	var stage_node = get_parent()
		
	var shot_instance = bullet_scene.instance()
	shot_instance.position = position + Vector2(32, 3)
	stage_node.add_child(shot_instance)
	
	var casing_instance = casing_scene.instance()
	rng.randomize()
	casing_instance.position = position + Vector2(rng.randi_range(-48, -16), rng.randi_range(16, 32))
	stage_node.add_child(casing_instance)

func _on_reload_timer_timeout():
	can_shoot = true

func _on_player_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("enemy_shot"):
		if invincibility > 0:
			return
			
		lives -= 1
		emit_signal("loose_life", lives)
		$invincibility_timer.start()
		
		if lives == 0:
			emit_signal("destroyed")
			queue_free()
			var stage_node = get_parent()
			var explosion_instance = player_death_scene.instance()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)


func _on_invincibility_timer_timeout():
	if invincibility == INVINCIBILITY_CYCLES:
		invincibility = 0
		$fella.modulate = Color(1, 1, 1)
		$invincibility_timer.stop()
	else:
		invincibility += 1
		
		if invincibility % 2 != 0:
			$fella.modulate = Color(1, 0, 0)
			$invincibility_timer.start()
		else:
			$fella.modulate = Color(1, 1, 1)
			$invincibility_timer.start()


func _on_javelin_animation_finished():
	$javelin.stop()
