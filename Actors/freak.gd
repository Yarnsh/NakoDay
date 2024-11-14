extends CharacterBody3D

@onready var armature = $manquin/Armature
@onready var anim = $manquin/AnimationPlayer
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	anim.play("Walk")

func _physics_process(delta):
	if is_on_floor():
		velocity = quaternion * armature.quaternion * (anim.get_root_motion_position())
		velocity.y = 0.0
	velocity.y -= gravity * delta
	move_and_slide()
