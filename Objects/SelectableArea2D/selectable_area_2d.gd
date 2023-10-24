class_name SelectableArea2D
extends Area2D

signal selection_changed(selected)

## The InputActions name used to detect when a left mouse
## click action happens inside the *SelectableArea2D*
@export var select_action := "select"

var selected := false:
	set(value):
		selected = value
		if value:
			add_to_group("selected")
		else:
			remove_from_group("selected")
		emit_signal("selection_changed", selected)
	get:
		return selected
		

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed(select_action):
		selected = not selected

# Capture "unselect" when clicking outside. Requires lots of munging of `set_process_unhandled_input`A
func _ready():
	set_process_unhandled_input(false)

func _on_mouse_entered():
	set_process_unhandled_input(false)

func _on_mouse_exited():
	# only process unhandled input if (1) we've exited the node (2) it is currently selected
	set_process_unhandled_input(selected)
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed(select_action):
		selected = false
		set_process_unhandled_input(false)
