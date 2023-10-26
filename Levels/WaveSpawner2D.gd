class_name WaveSpawner2D
extends Marker2D

signal spawned(spawn)

@export var spawn_scene: PackedScene

func spawn():
	var spawn = spawn_scene.instantiate()
	add_child(spawn)
	
	# prevent's WaveSpawner2D's transform from affected the spawn
	spawn.top_level = true
	spawn.global_position = global_position
	
	emit_signal("spawned", spawn)
	
	return spawn
