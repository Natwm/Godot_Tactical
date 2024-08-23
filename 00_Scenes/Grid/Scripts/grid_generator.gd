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

### ENUM ###
const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}
var _active_unit
var _walkable_cells := []

# Called when the node enters the scene tree for the first time.
func _ready():
	space_state = get_world_3d().direct_space_state
	Create_Analyse_board()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(grid_param):
		DebugDraw3D.draw_box(global_position,Quaternion.IDENTITY,Vector3(grid_param.grid_size.x,.25,grid_param.grid_size.y),Color.GREEN)
	pass

func Create_Analyse_board():
	for x in range(grid_param.grid_size.x):
		for y in range(grid_param.grid_size.y):
			var current_analyse_element : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
				Vector3(x + grid_param._half_cell_size,2,y + grid_param._half_cell_size),
				Vector3(x + grid_param._half_cell_size,-1,y + grid_param._half_cell_size)) 
			
			var result :Dictionary = space_state.intersect_ray(current_analyse_element)
			if(!result.is_empty()):
				#print("position = ("+ str(x) + "," + str(y) + ") = Result " + result.collider.name )
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

func create_tile(position :Vector3) -> Node3D:
	if(!tile.can_instantiate()):
		return null
	
	var new_tile :Node = tile.instantiate()
	grid.add_child(new_tile)
	
	new_tile.name = str(position)
	
	new_tile.global_position = position
	if(new_tile is Base_Tile):
		new_tile.set_up_tile()
	return new_tile


func Get_walkable_tile() -> Array :
	var walkable_tile : Array
	for tile_position in gameboard:
		#print(str(tile_position))
		walkable_tile.append(Vector2(tile_position.x,tile_position.z))
		pass
	return walkable_tile
	pass

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return _units.has(cell)
	
func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var array := []
	var stack := [cell]
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not grid_param.is_within_bounds(current):
			continue
		if current in array:
			continue
			
		var heuristic_value := GetHeuristique(current)
		if heuristic_value < 0:
			continue

		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y) + (heuristic_value - 1)
		if distance > max_distance:
			continue

		array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			# Minor optimization: If this neighbor is already queued
			#	to be checked, we don't need to queue it again
			if coordinates in stack:
				continue
			if(!gameboard.has(Vector3(coordinates.x,0,coordinates.y))):
				continue
			
			stack.append(coordinates)
	return array

func GetHeuristique(current: Vector2) -> int:
	var tile = gameboard[Vector3(current.x,0,current.y)]
	print(str(tile.value))
	return gameboard[Vector3(current.x,0,current.y)].value
