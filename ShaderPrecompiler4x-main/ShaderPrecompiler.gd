extends Node3D

@export var numFrames: int = 5  # The number of frames to display all materials

signal allShadersCompiled  # This signal is emitted when the node frees itself (i.e., all materials are compiled)

var _counter: int = 0
var _foundMaterials: Array
var _allMeshesDisplayed: bool = false


func _ready():
	_recursive_get_materials(get_tree().root)


func _process(_delta: float) -> void:
	_rotate_children()
	
	_counter += 1
	if _counter == numFrames:
		queue_free()
		emit_signal("allShadersCompiled")


func _recursive_get_materials(node: Node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			var mesh: MeshInstance3D = child as MeshInstance3D
			
			for i in range(mesh.mesh.get_surface_count()):
				var mat = mesh.mesh.surface_get_material(i)
					
				if is_instance_valid(mat):
					if not mat in _foundMaterials:
						_add_material(mat)
						_foundMaterials.append(mat)
		
		elif child is GPUParticles3D:
			var new_child = child.duplicate(0) as GPUParticles3D
			self.add_child(new_child)
			new_child.global_position = self.global_position
			new_child.emitting = true
		
		_recursive_get_materials(child)


func _add_material(material: Material) -> void:
	var quad: QuadMesh = QuadMesh.new()
	var newMesh: MeshInstance3D = MeshInstance3D.new()
	newMesh.mesh = quad
	newMesh.mesh.surface_set_material(0, material)
	
	add_child(newMesh)
	newMesh.set_owner(self)
	
	newMesh.global_transform.origin.x += randf() - 0.5
	newMesh.global_transform.origin.x += randf()/2 - 0.25
	newMesh.global_transform.origin.z += randf() - 0.5


func _rotate_children() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var mesh: MeshInstance3D = child as MeshInstance3D
			mesh.rotate_x(randf() * 0.2)
			mesh.rotate_y(randf() * -0.3)
			mesh.rotate_z(randf() * 0.1)
