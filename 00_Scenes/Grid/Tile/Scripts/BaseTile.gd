extends Node

class_name Bas_Tile

### OnReady ###
@onready var mesh_instance_3d = $MeshInstance3D
const NOT_ON_PATH_MAT = preload("res://03_Materials/NotOnPathMat.tres")
const ON_PATH_MAT = preload("res://03_Materials/OnPathMat.tres")

func set_up_tile():
	mesh_instance_3d.mesh.material = NOT_ON_PATH_MAT
	$MeshInstance3D2.visible = false
	pass

func set_on_path():
	mesh_instance_3d.mesh.material = ON_PATH_MAT
	$MeshInstance3D2.visible = true
	$MeshInstance3D.visible = false
	
	pass
