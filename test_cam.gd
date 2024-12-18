extends Node3D

@onready var main_scene = $"../../../.."
@export var cams : Array[Camera3D]
@export var no_fov_cams : Array[Camera3D]
@onready var cast = $ShapeCast3D
@onready var interact_button = $InteractButton
@onready var interact_button2 = $InteractButton2
@onready var character = $".."
@onready var subtitles = $Subtitles
@onready var subtitles2 = $Subtitles2
@onready var subs2player = $Subs2
var last_interactable = null
var pitch = 0.0
var yaw = 0.0
var mouse_sensitivity = 1.0

var offset = Vector3.ZERO

func _ready():
	cast.add_exception(character)
	pitch = global_rotation.x
	yaw = global_rotation.y
	set_fov(main_scene.get_fov())
	main_scene.settings.connect("fov_changed", set_fov)
	set_mouse_sensitivity(main_scene.get_mouse_sensitivity())
	main_scene.settings.connect("mouse_sensitivity_changed", set_mouse_sensitivity)

func give_offset():
	var target_dir = Vector3.UP.rotated(Vector3.RIGHT, randf_range(0.0, 2.0*PI)).rotated(Vector3.FORWARD, randf_range(0.0, 2.0*PI))
	offset = target_dir * 0.2

func set_fov(fov):
	for cam in cams:
		cam.fov = fov

func set_mouse_sensitivity(ms):
	mouse_sensitivity = ms

func set_grot(grot):
	global_rotation = grot
	pitch = global_rotation.x
	yaw = global_rotation.y

func _process(delta):
	if offset.length_squared() > 0.0:
		var length = offset.length()
		length = max(0.0, length - delta)
		offset =  offset.normalized() * length
	
	if character.state == character.NORMAL_STATE:
		global_rotation = Vector3(pitch, yaw, 0.0)
		set_subtitles("")
	elif character.state == character.CUTSCENE_STATE:
		pitch = global_rotation.x
		yaw = global_rotation.y
	
	for cam in cams:
		cam.global_position = global_position + offset
		cam.global_rotation = global_rotation
	for cam in no_fov_cams:
		cam.global_position = global_position + offset
		cam.global_rotation = global_rotation

func _physics_process(delta):
	if character.state == character.NORMAL_STATE:
		if cast.get_collision_count() > 0:
			interact_button.show()
			last_interactable = cast.get_collider(0)
		else:
			interact_button.hide()
			last_interactable = null
	elif character.state == character.CUTSCENE_STATE:
		interact_button.hide()
	
	if Input.is_action_just_pressed("interact") && last_interactable != null:
		last_interactable.interact(character)

func _input(event):
	if main_scene.mode != 0:
		return
	if event is InputEventMouseMotion:
		pitch -= event.relative.y * 0.01 * mouse_sensitivity
		yaw -= event.relative.x * 0.01 * mouse_sensitivity
		pitch = clampf(pitch, -PI/2.0 + 0.1, PI/2.0 - 0.1)

func set_subtitles(text):
	subtitles.text = text #TODO: make the text show up over time and not all at once
	if text == "":
		subtitles.hide()
		set_button_visible(false)
	else:
		subtitles.show()
		set_button_visible(true)

func set_popup(text):
	subtitles2.text = text
	subs2player.play("play")

func set_button_visible(v):
	interact_button2.visible = v
