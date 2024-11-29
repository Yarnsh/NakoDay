extends Area3D

@onready var sound = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func enable_ending():
	set_collision_mask_value(32, false)


func _on_body_entered(body):
	body.state = 1
	body.play_start_fall()
	sound.play()
