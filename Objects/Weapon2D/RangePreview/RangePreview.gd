class_name RangePreview
extends Sprite2D

@export var radius := 100.0
@export var tween_duration := 0.5

@onready var _gTween: Tween = null


func appear() -> void:
	var ratio = radius / texture.get_width()
	var final_scale = Vector2(ratio, ratio) * 2.0
	
	if _gTween != null and _gTween.is_running():
		_gTween.stop()
		
	var _tween := create_tween()	
	_gTween = _tween
	
	_tween.set_trans(Tween.TRANS_QUINT)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", final_scale, tween_duration).from(scale)
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), tween_duration).from(modulate)
	_tween.play()


func disappear() -> void:
	if _gTween != null and _gTween.is_running():
		_gTween.stop()
	
	var _tween := create_tween()
	_gTween = _tween
	
	_tween.set_trans(Tween.TRANS_BACK) # overshoots -> juice!
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "scale", Vector2.ZERO, tween_duration).from(scale)
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), tween_duration * 2.0).from(modulate)
	_tween.play()
