extends CharacterBody3D

@onready var armature = $manquin/Armature
@onready var skeleton = $manquin/Armature/Skeleton3D
@onready var anim = $manquin/AnimationPlayer
@onready var decal = $"manquin/Armature/Skeleton3D/Physical Bone mixamorig1_Head/Decal"
@onready var dark = $"manquin/Armature/Skeleton3D/Physical Bone mixamorig1_Head/Dark"
@onready var particles = $GPUParticles3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var activate_noise = $ActivateNoise
@onready var hit_noise = $SlapNoise
@onready var loop_noise = $Loop

@export var static_anim = "Bite"

var alive = true
var attacking = false
var hitting = false
var attack_time = 0
@export var mode = 0
var prev_mode = 0
var wake_time = 0
var root_vel = Vector3.ZERO

const ATTACK_DISTANCE = 1.0
const HIT_DISTANCE = 1.2
const HIT_TIME = 1200

func _ready():
	skeleton.animate_physical_bones = true
	anim.play("Pose")

func _disable_character_collision():
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(4, false)

func _enable_character_collision():
	global_rotation.x = 0.0
	global_rotation.z = 0.0
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true)

func _process(delta):
	root_vel += anim.get_root_motion_position()

func _physics_process(delta):
	if !alive:
		return
	
	if mode == 0: # static non-character thing
		static_mode(delta)
	elif mode == 1: # chasing
		if prev_mode == 0:
			activate_noise.play()
			loop_noise.play()
		chase_mode(delta)
	elif mode == 2: # randomized wakeup wait
		if prev_mode == 0:
			wake_time = Time.get_ticks_msec() + randi_range(0, 1200)
		if Time.get_ticks_msec() >= wake_time:
			mode = 1
			prev_mode = 0 # dirty hack
			return
	elif mode == 3: # just play an animation with root motion for scares and the like
		if prev_mode != 3:
			loop_noise.play()
		anim_mode(delta)
	else:
		_disable_character_collision()
		loop_noise.stop()
		anim.stop()
		decal.emission_energy = 0
		dark.light_energy = 0
	
	root_vel = Vector3.ZERO
	prev_mode = mode

func static_mode(delta):
	_disable_character_collision()
	decal.emission_energy = max(decal.emission_energy - delta, 0.0)
	dark.light_energy = max(dark.light_energy - (delta * 0.25), 0.0)

func chase_mode(delta):
	_enable_character_collision()
	decal.emission_energy = min(decal.emission_energy + delta, 1.0)
	dark.light_energy = min(dark.light_energy + (delta * 0.25), 1)
	var p = Global.player
	if p != null:
		if !attacking:
			if is_on_floor():
				anim.play("Walk")
				look_at_from_position(Vector3(global_position.x, p.global_position.y, global_position.z), p.global_position, Vector3.UP)
				velocity = quaternion * armature.quaternion * (root_vel)
				velocity.y = 0.0
			else:
				pass # some kinda fall logic
			
			if p.global_position.distance_to(global_position) < ATTACK_DISTANCE:
				anim.play("Swipe")
				attack_time = Time.get_ticks_msec()
				attacking = true
				hitting = true
		elif hitting:
			velocity = Vector3.ZERO
			if attack_time + HIT_TIME <= Time.get_ticks_msec():
				hitting = false
				if p.global_position.distance_to(global_position) < HIT_DISTANCE:
					p.hit()
					hit_noise.play()
	else:
		anim.play("Idle")
	
	velocity.y -= gravity * delta
	move_and_slide()

func anim_mode(delta):
	_disable_character_collision()
	decal.emission_energy = 1.0
	dark.light_energy = 0
	anim.play(static_anim)
	velocity = Quaternion(global_basis) * (root_vel)
	move_and_slide()

func destroy():
	_disable_character_collision()
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)
	alive = false
	armature.hide()
	particles.emitting = true
	loop_noise.stop()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Swipe" and attacking:
		attacking = false
