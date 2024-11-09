extends MeshInstance3D

@onready var flame = $Flame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func light():
	flame.show()
