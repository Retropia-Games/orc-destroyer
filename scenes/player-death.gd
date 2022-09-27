extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	$AnimationPlayer.current_animation = "death"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 6
