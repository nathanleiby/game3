class_name Bullet
extends Node2D

## speed in units of ???
@export var speed := 500

@onready var _anim_player := $AnimationPlayer

func _init():
	# Avoids having its parent affect its transform
	top_level = true
	
func fly_to(target_global_position: Vector2):
	var distance := global_position.distance_to(target_global_position)
	var duration := distance / speed
	
	var _tween := create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.tween_property(self, "global_position", target_global_position, duration).from_current()
	# TODO: is _tween.play() needed?
	
	look_at(target_global_position)
	await _tween.finished
	_anim_player.play("explode")
	
