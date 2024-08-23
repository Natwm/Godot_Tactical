extends Node3D

@onready var grid_generator : GameboardCreator = $"Grid Generator"

@export var cell_start : Vector2
@export var cell_end : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("Debug")):
		var a = PathFinder.new(grid_generator.grid_param,grid_generator._flood_fill(cell_start,50))
		var path = a.calculate_point_path(cell_start, cell_end)
		Display_path(path)
	pass


func Display_path(path: Array):
	var index :int = 0 
	if(path.size()<=0):
		print("error")
		return
	for path_position :Vector2 in path :
		#print(str(index) +" "+ str(path_position))
		var selected_position :Vector3 = Vector3(path_position.x,0,path_position.y)
		var tile = grid_generator.gameboard[selected_position]
		
		if(tile == null):
			print("error")
			return
			
		if(tile is Base_Tile):
			tile.set_on_path()
			pass
			index +=1
	pass
