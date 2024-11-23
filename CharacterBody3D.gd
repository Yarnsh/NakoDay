extends CharacterBody3D

@onready var main_scene = $"../../.."
@onready var game_scene = $".."

@onready var scary_music = $"../ScaryMusic"
@onready var action_music = $"../ActionMusic"

@onready var cam = $RootCam
@onready var view_pos = $RootCam/ViewPos
@onready var foot_sfx = $Foot

@onready var sfx_player = $SFXPlayer

@export var screams : Array[AudioStream] = []

@onready var grassy_foot_step = load("res://SFX/footstep.wav")
@onready var stony_foot_step = load("res://SFX/stone_footstep.wav")
@export var grassy_collider : StaticBody3D

@onready var rustling_foot = $Foot2
var rustle_movement = false

@onready var interact_1 = $"RootCam/InteractButton"
@onready var interact_2 = $"RootCam/InteractButton2"

@export var camera_obj : Node3D
@export var shotgun_obj : Node3D
@export var fade_anim : AnimationPlayer

var SPEED = 2.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var was_on_floor = false
var was_moving = false
var foot_start_time = 999999999999.9
const foot_delay = 350

var tele_transform = Transform3D.IDENTITY
var tele_time = -1

const NORMAL_STATE = 0
const CUTSCENE_STATE = 1
@export var state = NORMAL_STATE

var action_fade_out = false

func _ready():
	Global.player = self
	fade_anim.play("FadeIn")
	rustling_foot.set_stream_paused(true)

func start_scary_music():
	if !scary_music.playing:
		scary_music.play()

func stop_scary_music():
	scary_music.stop()

func start_action_music():
	action_music.play()

func stop_action_music():
	action_fade_out = true

func hit():
	play_sfx(screams[randi_range(0,2)], 0.0)
	cam.give_offset()

func give_shotgun():
	camera_obj.hide()
	shotgun_obj.show()
	shotgun_obj.anim.play("pump")

func teleport_to(t_pos):
	fade_anim.play("Fade")
	tele_transform = t_pos
	tele_time = Time.get_ticks_msec() + 2000

func play_sfx(sound, db):
	sfx_player.stream = sound
	sfx_player.volume_db = db
	sfx_player.play()

func _process(delta):
	# bit of a waste to do this every frame but honestly who cares anymore
	interact_1.text = InputMap.action_get_events("interact")[0].as_text()
	interact_2.text = InputMap.action_get_events("interact")[0].as_text()
	
	if scary_music.playing:
		scary_music.volume_db = min(0.0, scary_music.volume_db + (delta * 40.0))
	if action_fade_out:
		action_music.volume_db = max(-40.0, action_music.volume_db - (delta * 20.0))

func _physics_process(delta):
	var now = Time.get_ticks_msec()
	
	# debug stuff
	if Global.debug and Input.is_action_pressed("speed_up"):
		SPEED = 22.0
	else:
		SPEED = 3.0
	
	if (state == NORMAL_STATE):
		if is_on_floor():
			var col = get_last_slide_collision()
			if col != null:
				if col.get_collider() == grassy_collider:
					if foot_sfx.stream != grassy_foot_step:
						foot_sfx.stream = grassy_foot_step
						AudioServer.set_bus_effect_enabled(1, 0, false)
				else:
					if foot_sfx.stream != stony_foot_step:
						foot_sfx.stream = stony_foot_step
			
			if !was_on_floor or (was_moving and now >= foot_start_time + foot_delay):
				foot_start_time = now
				foot_sfx.play()
			velocity = Vector3(0.0,velocity.y,0.0)
			if !was_moving:
				foot_start_time = Time.get_ticks_msec()
			was_moving = false
			if main_scene.mode == 0:
				if Input.is_action_pressed("left"):
					velocity += Vector3.LEFT.rotated(Vector3.UP, cam.yaw)
					was_moving = true
				if Input.is_action_pressed("right"):
					velocity += Vector3.RIGHT.rotated(Vector3.UP, cam.yaw)
					was_moving = true
				if Input.is_action_pressed("forward"):
					velocity += Vector3.FORWARD.rotated(Vector3.UP, cam.yaw)
					was_moving = true
				if Input.is_action_pressed("back"):
					velocity += Vector3.BACK.rotated(Vector3.UP, cam.yaw)
					was_moving = true
			
			velocity = velocity.normalized() * SPEED
			
			if was_moving and rustle_movement and !rustling_foot.playing:
				rustling_foot.set_stream_paused(false)
			elif (!was_moving or !rustle_movement) and rustling_foot.playing:
				rustling_foot.set_stream_paused(true)
			
			if ((Input.is_action_just_released("left")
				or Input.is_action_just_released("right")
				or Input.is_action_just_released("back")
				or Input.is_action_just_released("forward"))
				and (velocity.x == 0 and velocity.y == 0)):
				foot_sfx.play()
			
			was_on_floor = true
		else:
			velocity.y -= gravity * delta
			was_on_floor = false
	
	elif (state == CUTSCENE_STATE):
		if tele_time > 0 and tele_time < Time.get_ticks_msec():
			global_position = tele_transform.origin
			cam.global_basis = tele_transform.basis
			tele_time = -1
		
		if is_on_floor():
			velocity.x = 0.0
			velocity.z = 0.0
		else:
			velocity.y -= gravity * delta
	
	move_and_slide()

func kill(description, sound, db):
	main_scene.loaded_flags = game_scene.get_flags()
	main_scene.show_death(description, sound, db)
