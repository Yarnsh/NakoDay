extends Node3D

@onready var anim = $AnimationPlayer
@onready var side_node = $SidePosition
@onready var model = $Sketchfab_model
var side_transform : Transform3D
@onready var aimed_transform = model.transform
var target_transform : Transform3D
@onready var shooter = $"Sketchfab_model/406997d5f9db455fa4abe2ebfdb2caff_fbx/RootNode/Remington870/Body/Shooter"

func _ready():
	side_transform = side_node.transform
	target_transform = side_transform

func _process(delta):
	var rate = 3.0
	#model.transform = model.transform.interpolate_with(target_transform, (rate * delta)*(rate * delta))
	var dir = model.transform.origin.direction_to(target_transform.origin)
	var dist = model.transform.origin.distance_to(target_transform.origin)
	
	if dist <= rate*delta:
		model.transform.origin = target_transform.origin
	else:
		model.transform.origin += dir * rate * delta

func set_aimed(aimed):
	if aimed:
		target_transform = aimed_transform
	else:
		target_transform = side_transform

func shoot():
	shooter.shoot()
