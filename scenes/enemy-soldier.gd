extends Area2D

export var shots_count = 10
export var move_speed = 10
var counter = 0

var explosion_scene = preload("res://scenes/enemy-death.tscn")
var shot_scene = preload("res://scenes/enemy-bullet.tscn")
var casing_scene = preload("res://scenes/casing.tscn")
var rng = RandomNumberGenerator.new()

var score_emitted = false

signal score

func _ready():
	$shot_timer.start()

func _process(delta):
	position -= Vector2(move_speed * delta, 0.0)
	
	if position.x <= 0:
		queue_free()

func _on_enemy_soldier_area_entered(area):
	if area.is_in_group("bullet") || area.is_in_group("shot"):
		if not  score_emitted:
			score_emitted = true
			emit_signal("score")
			queue_free()
			
			var stage_node = get_parent()
			var explosion_instance = explosion_scene.instance()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)


func _on_shot_timer_timeout():
	counter += 1
	
	if counter < shots_count:
		shoot()
		$ak47.play("default")
	else:
		counter = 0
		$shot_timer.stop()
		$reload_timer.start()
		$ak47.stop()
		$ak47.frame = 0

func shoot():
	var stage_node = get_parent()
	var shot_instance = shot_scene.instance()
	shot_instance.position = position - Vector2(32, -6)
	stage_node.add_child(shot_instance)
	var casing_instance = casing_scene.instance()
	rng.randomize()
	casing_instance.position = position + Vector2(rng.randi_range(48, 16), rng.randi_range(16, 32))
	stage_node.add_child(casing_instance)
	
func _on_reload_timer_timeout():
	$shot_timer.start()
