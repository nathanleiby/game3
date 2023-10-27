class_name WaveSpawner2D
extends Marker2D

signal spawned(spawn)

@export var spawn_scene: PackedScene

func spawn():
	var _spawn = spawn_scene.instantiate()
	add_child(_spawn)
	
	# prevent's WaveSpawner2D's transform from affected the spawn
	_spawn.top_level = true
	_spawn.global_position = global_position
	
	emit_signal("spawned", _spawn)
	
	return _spawn
