extends Area3D

@onready var scare_light = $"../../FinalScareLight"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	body.start_scary_music()
	set_collision_mask_value(32, false)
	scare_light.show()
	for child in get_children():
		if child is CharacterBody3D:
			child.mode = 2
