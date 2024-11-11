extends OmniLight3D

@export var shotgun_model : Node3D
@export var follow_node : Node3D
@export var shell_prefab : PackedScene
@export var shell_spawn_node : Node3D
@export var player : CharacterBody3D
@onready var noise = $GunNoise
const flash_strength = 6.0

@export var should_spawn_shell = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform = follow_node.global_transform
	
	var rate = 30
	light_energy = max(light_energy - (rate * delta), 0.0)
	
	if should_spawn_shell:
		var shell = shell_prefab.instantiate()
		get_parent().add_child(shell)
		shell.global_transform = shell_spawn_node.global_transform
		shell.set_linear_velocity((shell_spawn_node.global_basis.x * 3.0) + player.velocity)
		shell.set_angular_velocity(Vector3.UP * 4.0)
		should_spawn_shell = false

func fire():
	light_energy = flash_strength
	shotgun_model.anim.play("fire_and_pump")
	shotgun_model.shoot()
	noise.play()

func _input(event):
	if shotgun_model.visible and !shotgun_model.anim.is_playing() and event.is_action_pressed("Action"):
		fire()
	elif event.is_action_pressed("Aim"):
		shotgun_model.set_aimed(true)
	elif event.is_action_released("Aim"):
		shotgun_model.set_aimed(false)
