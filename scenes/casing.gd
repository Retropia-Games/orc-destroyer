extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Timer.wait_time = rng.randi_range(8, 20)
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
