extends Area3D

@onready var cake = $"../Cake"
@onready var present = $"../present"
@onready var door = $"../DestroyableBars"

var prepare = false
var wait_time = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if prepare:
		wait_time -= delta
		if wait_time <= 0.0:
			prepare = false
			cake.light()
			present.allow_pickup()
			# TODO: sounds and stuff


func _on_body_entered(body):
	set_collision_mask_value(32, false)
	door.close()
	prepare = true
