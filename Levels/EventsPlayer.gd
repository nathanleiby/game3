extends AnimationPlayer

@export var current_event := 0

# TODO: is this a default fn arg value (and implied type?)
func play_event(event_index := current_event):
	# stores list of animations. checks if event_index is in range
	var events_list := get_animation_list()
	var animation_count := len(events_list)
	if event_index >= animation_count:
		return
	
	play(events_list[event_index])
	
# TODO: do we need another method here? If so, why bother with default function value above?
func play_current_event():
	play_event()
	current_event += 1


func _on_wave_spawner_2d_spawned(spawn):
	print("spawned", spawn)
	spawn.start()
	await spawn.finished
	play_current_event()
