@tool
extends Node3D
class_name GameboardCreator

### Export ###
@export_category("Resources")
@export var grid_param : Grid_parametter

@export_category("Prefabs")
@export var tile : PackedScene


### ready ###
@onready var cast = $cast
@onready var grid = $grid

### ready ###
var analyse_element : Array
var space_state : PhysicsDirectSpaceState3D
var gameboard : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	space_state = get_world_3d().direct_space_state
	Create_Analyse_board()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(grid_param):
		DebugDraw3D.draw_box(global_position,Quaternion.IDENTITY,Vector3(grid_param.grid_size.x,.25,grid_param.grid_size.y),Color.GREEN)
		
		#for x in range(grid_param.grid_size.x):
			#for y in range(grid_param.grid_size.y):
				#DebugDraw3D.draw_cylinder_ab(Vector3(0.5+x,2,0.5+y),Vector3(0.5+x,0,0.5+y),0.25,Color.RED,1000)

	pass

func Create_Analyse_board():
	for x in range(grid_param.grid_size.x):
		for y in range(grid_param.grid_size.y):
			var current_analyse_element : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
				Vector3(x + grid_param._half_cell_size,2,y + grid_param._half_cell_size),
				Vector3(x + grid_param._half_cell_size,-1,y + grid_param._half_cell_size)) 
			
			var result :Dictionary = space_state.intersect_ray(current_analyse_element)
			if(!result.is_empty()):
				print("position = ("+ str(x) + "," + str(y) + ") = Result " + result.collider.name )
				gameboard[Vector3(x,0,y)] = create_tile(Vector3(x,0,y))
			pass
		pass
	pass

func create_Capsule_cast() -> ShapeCast3D:
	### Creation of the cast element
	var detection_ground :ShapeCast3D = ShapeCast3D.new()
	detection_ground.shape = CapsuleShape3D.new()
			
	### SetUp Cast element
	detection_ground.shape.radius /= 2
	cast.add_child(detection_ground)
	return detection_ground

func create_tile(position :Vector3) -> Node:
	if(!tile.can_instantiate()):
		return null
	
	var new_tile := tile.instantiate()
	grid.add_child(new_tile)
	
	new_tile.global_position = position
	if(new_tile.has_method("set_up_tile")):
		print("good")
		new_tile.set_up_tile()
	return new_tile
