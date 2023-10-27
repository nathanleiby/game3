class_name AStarGrid
extends TileMap


var _astar := AStar2D.new()

@export var start_point := Vector2i.ZERO
@export var goal_point := Vector2i.ZERO

var walkable_cells: PackedVector2Array

var _start_id := 0
var _goal_id := 0

func _create_astar_points():
	var cell_idx := 0
	# trying out functional code https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-map
	var cells := Array(walkable_cells).map(func(v): return Vector2i(v))
	for cell in cells:
		_astar.add_point(cell_idx, cell)
		if cell == local_to_map(start_point):
			_start_id = cell_idx
		if cell == local_to_map(goal_point):
			_goal_id = cell_idx
		
		cell_idx += 1 

const NEIGHBOR_DIRECTIONS := [
	Vector2.UP,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.DOWN,
]

func _connect_neighbor_cells():
	var walkable_cells_array := Array(walkable_cells)
	for point in _astar.get_point_ids():
		var cell = _astar.get_point_position(point)
		
		for direction in NEIGHBOR_DIRECTIONS:
			var neighbor_cell_idx := walkable_cells_array.find(cell + direction)
			if neighbor_cell_idx != -1:
				_astar.connect_points(point, neighbor_cell_idx)

func _get_astar_path() -> PackedVector2Array:
	var astar_path: PackedVector2Array
	_create_astar_points()
	_connect_neighbor_cells()
	
	astar_path = _astar.get_point_path(_start_id, _goal_id)
	
	# TODO: How does it handle no path found?
	
	return astar_path

@export var offset := Vector2(32, 32)

func get_walkable_path() -> PackedVector2Array:
	var walkable_path := PackedVector2Array()
	var astar_path := _get_astar_path()
	
	for cell in astar_path:
		# convert from point to cell_idx
		# get tile coords by cell_idx
		# map to world coords
		var point := map_to_local(cell)
		# offset to get center of tile, which is where we want to position the path
		walkable_path.append(to_global(point) + offset)		
	
	return walkable_path
		
