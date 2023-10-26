class_name Enemy
extends PathFollow2D

signal died(gold_amount)

## movement speed (pixels per second)
@export var speed := 64.0

## gold earned when this enemy dies
@export var gold_value := 50

@export var max_health := 15
@onready var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		_health_bar.value = health
		
		if health < 1:
			die()
	get:
		return health

@onready var _anim_player := $AnimationPlayer
@onready var _cutout_anim_player := $CutoutCharacter/AnimationPlayer
@onready var _ui_pivot := $UIPivot
@onready var _health_bar := $UIPivot/HealthBar
		
func _ready():
	# don't move until it has finished spawn animation
	set_physics_process(false)
	
	# TODO: why? remove from this scene tree, so it's not modified by it?
	_ui_pivot.top_level = true
	
	_health_bar.max_value = max_health
	_health_bar.value = health
	
	
func _physics_process(delta: float):
	# was `offset` in godot3
	progress += speed * delta
	
	# was `unit_offset` in godot3
	if progress_ratio >= 1.0:
		set_physics_process(false)
		disappear()

func move():
	set_physics_process(true)
	_cutout_anim_player.play("move")
	
func disappear():
	_anim_player.play("disappear")

func die():
	emit_signal("died", gold_value)
	disappear()


func _on_hurt_box_area_2d_hit_landed(damage):
	health -= damage
