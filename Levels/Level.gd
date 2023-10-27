extends Node2D

@onready var _path_preview := $PathPreview
@onready var _astar_grid: AStarGrid = $AStarGrid as AStarGrid

@onready var _tilemap := $TileMap
@onready var _start_point := $StartPoint
@onready var _goal_point := $GoalPoint

const WALKABLE_CELLS_SOURCE_ID := 1 # tiles from "enemy walking path cell" # NOTE: was 2 in tutorial.

func _ready():
	_path_preview.clear_points()
	_astar_grid.start_point = _start_point.global_position
	_astar_grid.goal_point = _goal_point.global_position

	_astar_grid.walkable_cells = _tilemap.get_used_cells_by_id(0, WALKABLE_CELLS_SOURCE_ID)
	_path_preview.points = _astar_grid.get_walkable_path()

	# TODO: next up is connecting this to the enemy path
