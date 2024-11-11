extends StaticBody3D

@export var open = false
@onready var bars = $bars_door
var open_offset = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if open:
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, false)
		bars.position.y = open_offset

func _process(delta):
	if open:
		bars.position.y = min(open_offset, bars.position.y + (4.5 * delta))
	else:
		bars.position.y = max(0.0, bars.position.y - (4.5 * delta))

func close():
	open = false
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)
	# TODO: play closing sound

func destroy():
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	
	hide()
	# TODO: effects and breaking sound stuff
