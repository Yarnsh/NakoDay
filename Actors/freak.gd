extends CharacterBody3D

@onready var armature = $manquin/Armature
@onready var skeleton = $manquin/Armature/Skeleton3D
@onready var anim = $manquin/AnimationPlayer
@onready var decal = $"manquin/Armature/Skeleton3D/Physical Bone mixamorig1_Head/Decal"
@onready var light = $"manquin/Armature/Skeleton3D/Physical Bone mixamorig1_Head/OmniLight3D"
@onready var particles = $GPUParticles3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var activate_noise = $ActivateNoise
@onready var hit_noise = $SlapNoise

var alive = true
var attacking = false
var hitting = false
var attack_time = 0
var mode = 0
var prev_mode = 0
var wake_time = 0

const ATTACK_DISTANCE = 1.0
const HIT_DISTANCE = 1.2
const HIT_TIME = 1200

func _ready():
	skeleton.animate_physical_bones = true
	anim.play("Pose")

func _disable_character_collision():
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)

func _enable_character_collision():
	global_rotation.x = 0.0
	global_rotation.z = 0.0
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, true)

func _physics_process(delta):
	if !alive:
		return
	
	if mode == 0: # static non-character thing
		static_mode(delta)
	elif mode == 1: # chasing
		if prev_mode == 0:
			activate_noise.play()
		chase_mode(delta)
	elif mode == 2: # randomized wakeup wait
		if prev_mode == 0:
			wake_time = Time.get_ticks_msec() + randi_range(0, 1200)
		if Time.get_ticks_msec() >= wake_time:
			mode = 1
			prev_mode = 0 # dirty hack
			return
	
	prev_mode = mode

func static_mode(delta):
	_disable_character_collision()
	decal.emission_energy = max(decal.emission_energy - delta, 0.0)
	light.light_energy = max(light.light_energy - (delta * 0.25), 0.0)

func chase_mode(delta):
	_enable_character_collision()
	decal.emission_energy = min(decal.emission_energy + delta, 1.0)
	light.light_energy = min(light.light_energy + (delta * 0.25), 0.25)
	var p = Global.player
	if p != null:
		if !attacking:
			if is_on_floor():
				anim.play("Walk")
				look_at_from_position(Vector3(global_position.x, p.global_position.y, global_position.z), p.global_position, Vector3.UP)
				velocity = quaternion * armature.quaternion * (anim.get_root_motion_position())
				velocity.y = 0.0
			else:
				pass # some kinda fall logic
			
			if p.global_position.distance_to(global_position) < ATTACK_DISTANCE:
				anim.play("Swipe")
				attack_time = Time.get_ticks_msec()
				attacking = true
				hitting = true
		elif hitting:
			if attack_time + HIT_TIME <= Time.get_ticks_msec():
				hitting = false
				if p.global_position.distance_to(global_position) < HIT_DISTANCE:
					p.hit()
					hit_noise.play()
	else:
		anim.play("Idle")
	
	velocity.y -= gravity * delta
	move_and_slide()

func destroy():
	_disable_character_collision()
	set_collision_layer_value(4, false)
	set_collision_mask_value(1, false)
	alive = false
	armature.hide()
	particles.emitting = true
	# TODO: death sound effects

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Swipe" and attacking:
		attacking = false
