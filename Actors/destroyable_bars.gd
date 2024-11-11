extends StaticBody3D

@export var open = false
@onready var bars = $bars_door
var open_offset = 2.5
var destroy_queued = false

@onready var p1 = $DoorDestroyEffect/GPUParticles3D
@onready var p2 = $DoorDestroyEffect/GPUParticles3D2
@onready var p3 = $DoorDestroyEffect/Spark
@onready var sound = $DoorDestroyEffect/AudioStreamPlayer3D
@onready var close_sound = $Close

# Called when the node enters the scene tree for the first time.
func _ready():
	if open:
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, false)
		bars.position.y = open_offset

func _process(delta):
	if open:
		bars.position.y = min(open_offset, bars.position.y + (9.5 * delta))
	else:
		bars.position.y = max(0.0, bars.position.y - (9.5 * delta))
	
	if destroy_queued:
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, false)
		
		bars.hide()
		p1.emitting = true
		p2.emitting = true
		p3.emitting = true
		sound.play()
		# TODO: breaking sound stuff
		destroy_queued = false

func close():
	open = false
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)
	close_sound.play()

func destroy():
	if !destroy_queued:
		destroy_queued = true
