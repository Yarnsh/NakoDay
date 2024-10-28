extends StaticBody3D

@onready var teleport_location = $Location

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(c):
	c.teleport_to(teleport_location.global_position)
