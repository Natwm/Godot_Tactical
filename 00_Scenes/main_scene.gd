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
		var a = PathFinder.new(grid_generator.grid_param,grid_generator.gameboard)
		var path = a.calculate_point_path(cell_start, cell_end)
	pass
