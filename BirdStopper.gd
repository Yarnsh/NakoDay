extends Area3D

@onready var animp = $"../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	set_collision_mask_value(32, false)
	animp.play("stop_outdoor")
