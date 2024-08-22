extends Node

class_name Bas_Tile

### OnReady ###
@onready var mesh_instance_3d = $MeshInstance3D


func set_up_tile():
	mesh_instance_3d.mesh.material = StandardMaterial3D.new()
	mesh_instance_3d.mesh.material.albedo_color = Color.AQUA
	pass

func set_on_path():
	mesh_instance_3d.mesh.material.albedo_color = Color.RED
	pass
