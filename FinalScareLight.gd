extends DirectionalLight3D

var start_color
var end_color = Color.DIM_GRAY
var progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_color = light_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.scare_done:
		progress = min(1.0, progress + (delta * 0.2))
		light_color = start_color.lerp(end_color, progress)
