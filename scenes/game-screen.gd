extends ViewportContainer
var GrayscaleMaterial = preload("res://shaders/grayscale.tres")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Viewport/stage/player").connect("destroyed", self, "_on_player_destroyed")
	

func _on_player_destroyed():
	self.material = GrayscaleMaterial

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
