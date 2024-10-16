extends Node3D

@onready var anim = $AnimationPlayer
@onready var side_node = $SidePosition
@onready var model = $Sketchfab_model
var side_transform : Transform3D
@onready var aimed_transform = model.transform
var target_transform : Transform3D

func _ready():
	side_transform = side_node.transform
	target_transform = side_transform

func _process(delta):
	var rate = 50
	model.transform = model.transform.interpolate_with(target_transform, (rate * delta)*(rate * delta))

func set_aimed(aimed):
	if aimed:
		target_transform = aimed_transform
	else:
		target_transform = side_transform
