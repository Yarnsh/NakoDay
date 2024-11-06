extends StaticBody3D

@onready var visuals = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func breakaway():
	set_collision_layer_value(1, false)
	visuals.hide()
	# TODO: play the particles and broken shit animation
