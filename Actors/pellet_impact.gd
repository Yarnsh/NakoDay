extends Node3D

@onready var p1 = $GPUParticles3D
@onready var p2 = $GPUParticles3D2

# Called when the node enters the scene tree for the first time.
func _ready():
	p1.emitting = true
	p2.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gpu_particles_3d_finished():
	queue_free()
