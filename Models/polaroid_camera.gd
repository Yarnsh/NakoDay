extends Node3D

@onready var model = $Sketchfab_model
@onready var aimed_transform = $AimPosition.transform
@onready var side_transform = model.transform
@onready var screenshot_viewport = $Sketchfab_model/CamView
var target_transform : Transform3D

func _ready():
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
