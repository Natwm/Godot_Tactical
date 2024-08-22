extends Resource

class_name Grid_parametter

@export_category("Grid parameter")
@export var grid_size:Vector2

@export_category("Cell parameter")
@export var cell_size:float

var _half_cell_size : float :
	get():
		return cell_size / 2

# Returns the position of a cell's center in pixels.
# We'll place units and have them move through cells using this function.
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * grid_size * _half_cell_size

func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()

# Returns true if the `cell_coordinates` are within the grid.
# This method and the following one allow us to ensure the cursor or units can never go past the
# map's limit.
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < grid_size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < grid_size.y


# Makes the `grid_position` fit within the grid's bounds.
# This is a clamp function designed specifically for our grid coordinates.
# The Vector2 class comes with its `Vector2.clamp()` method, but it doesn't work the same way: it
# limits the vector's length instead of clamping each of the vector's components individually.
# That's why we need to code a new method.
func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, grid_size.x - 1.0)
	out.y = clamp(out.y, 0, grid_size.y - 1.0)
	var _astar := AStar2D.new()
	return out

# Given Vector2 coordinates, calculates and returns the corresponding integer index. You can use
# this function to convert 2D coordinates to a 1D array's indices.
#
# There are two cases where you need to convert coordinates like so:
# 1. We'll need it for the AStar algorithm, which requires a unique index for each point on the
# graph it uses to find a path.
# 2. You can use it for performance. More on that below.
func as_index(cell: Vector2) -> int:
	return int(cell.x + grid_size.x * grid_size.y)

## Makes the `grid_position` fit within the grid's bounds.
func grid_clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, grid_size.x - 1.0)
	out.y = clamp(out.y, 0, grid_size.y - 1.0)
	return out
