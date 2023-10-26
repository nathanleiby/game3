extends TileMap

const TESTING := true
	
func _ready():
	set_process_unhandled_input(false)
	
	if TESTING:
		setup_available_cells([Vector2(12,7), Vector2(13,8), Vector2(14,9)])
		var tower = load("res://Objects/Tower/Tower.tscn").instantiate()
		add_new_tower(tower)

#
# Handling available cells
#

const LAYER_ID := 0
## ID of cell that is available for placement
const AVAILABLE_CELL_ID := 0
## ID of cell that is occupied or obstructed
const INVALID_CELL_ID := 1

func set_cell_unplaceable(cell: Vector2):
	set_cell(LAYER_ID, cell, INVALID_CELL_ID, Vector2i(0,0))
	
func set_cell_placeable(cell: Vector2):
	set_cell(LAYER_ID, cell, AVAILABLE_CELL_ID, Vector2i(0,0))

func is_cell_placeable(cell: Vector2):
	return get_cell_source_id(LAYER_ID, cell) == AVAILABLE_CELL_ID


func setup_available_cells(cells_array: PackedVector2Array):
	for cell in cells_array:
		set_cell_placeable(cell)


#
# Placing towers
#

@onready var _visual_grid: TileMap = $VisualGrid as TileMap

var _current_tower: Tower

func add_new_tower(tower: Tower):
	if _current_tower:
		_current_tower.queue_free()
	add_child(tower)
	_current_tower = tower
	
	set_process_unhandled_input(true)
	_visual_grid.visible = true
	_snap_tower_to_grid()
	
var _current_cell := Vector2.ZERO

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		_snap_tower_to_grid()
	if event.is_action_pressed("tower_placement"):
		_place_tower()
	
func _snap_tower_to_grid():
	_current_cell = local_to_map(get_global_mouse_position())
	_current_tower.global_position = map_to_local(_current_cell)
	
	
	if not is_cell_placeable(_current_cell):
		_current_tower.modulate = Color(1, 0.375, 0.375)
	else:
		_current_tower.modulate = Color.WHITE

signal tower_placed(tower: Tower)

func _place_tower():
	set_process_unhandled_input(false)
	_visual_grid.visible = false
	
	if not is_cell_placeable(_current_cell):
		# clicking on an unplaceable square exits "placement" mode for that tower
		# (alternatively we could warn player of invalid interaction)
		_current_tower.queue_free()
		_current_tower = null
		return

	set_cell_unplaceable(_current_cell)
	emit_signal("tower_placed")
	_current_tower.connect("sold", _on_tower_sold)
	_current_tower = null
	
func _on_tower_sold(_price: int, place: Vector2):
	set_cell_placeable(local_to_map(place))
