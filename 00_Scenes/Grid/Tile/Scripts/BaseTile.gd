extends Node

class_name Base_Tile

const NOT_ON_PATH_MAT = preload("res://03_Materials/NotOnPathMat.tres")

### EXPORT ###
@export var value : int = 1


### OnReady ###
@onready var mesh_instance_3d = %MeshInstance3D

func set_up_tile():
	mesh_instance_3d.mesh.material = NOT_ON_PATH_MAT
	$MeshInstance3D2.visible = false
	pass

func set_on_path():
	var new_material := StandardMaterial3D.new()
	new_material.albedo_color = Color.REBECCA_PURPLE
	mesh_instance_3d.mesh.material = new_material
	mesh_instance_3d.mesh.surface_set_material(0, new_material)
	#$MeshInstance3D2.visible = true
	#$MeshInstance3D.visible = false
	
	pass
