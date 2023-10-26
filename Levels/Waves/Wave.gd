class_name Wave
extends Path2D

@export var TESTING := false

## Emitted when calling start() 
signal starting
## Emitted when all enemies have left the scene tree (i.e. they were killed or damaged the base)
signal finished

## Delay in seconds between spawn of two enemies
@export_range(0.1, 5.0, 0.05) var enemy_time_interval := 0.5


func start():
	print("start()")
	emit_signal("starting")
	_setup_enemies()
	_move_enemies()

func _setup_enemies():
	for enemy in get_children():
		enemy.progress = 0.0 # was unit_offset
		enemy.connect("tree_exited", _on_enemy_tree_exited)
	
func _move_enemies():
	for enemy in get_children():
		await get_tree().create_timer(enemy_time_interval).timeout
		enemy.move()

func set_movement_path(movement_path: PackedVector2Array):
	curve.clear_points()
	for point in movement_path:
		curve.add_point(point)
		
func is_wave_finished():
	return get_child_count() < 1
	
func _on_enemy_tree_exited():
	if is_wave_finished():
		emit_signal("finished")
		queue_free()

func _ready():
	if TESTING:
		print("wave.gd -> Testing!")
		start()

