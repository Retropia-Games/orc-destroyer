extends Node2D

var tank = preload("res://scenes/enemy-tank.tscn")

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

var is_game_over = false
var score = 0

func _ready():
	get_node("player").connect("destroyed", self, "_on_player_destroyed")
	get_node("player").connect("change_weapon", self, "_on_weapon_change")
	get_node("spawn_timer").connect("timeout", self, "_on_spawn_timer_timeout")
	
func _on_player_destroyed():
	get_node("ui/retry").show()
	is_game_over = true

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://scenes/stage.tscn")

func _on_spawn_timer_timeout():
	var tank_instance = tank.instance()
	tank_instance.position = Vector2(SCREEN_WIDTH + 16, rand_range(0, SCREEN_HEIGHT))
	tank_instance.connect("score", self, "_on_player_score")
	add_child(tank_instance)

func _on_player_score():
	score += 1
	get_node("ui/score").text = "Score: " + str(score)

func _on_weapon_change(weapon):
	print(weapon)
	get_node("ui/weapon").text = "Weapon: " + str(weapon)
