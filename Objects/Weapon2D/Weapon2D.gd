class_name Weapon2D
extends Node2D

const TESTING := false # Toggle to true and play this scene to explore shooting and animations

@export var bullet_scene: PackedScene

## range of the weapon in pixels
@export var fire_range := 200:
	set(value):
		# synchronize fire range with range area's radius
		fire_range = value
		
		if not is_inside_tree():
			await self.ready
		_range_shape.radius = value
	get:
		return fire_range

## cooldown in seconds to fire again
@export var fire_cooldown := 1.0

# TODO: Is there a way to avoid so much boilerplate linking the nodes with the code?
# What are the benefits of doing setup this way? It seems one is that refs are checked at runtime, so...
# 	@onready var _invalid_ref := $Invalid
# compiles. This pattern doesn't fix that problem afaik, it would just be a null ref, right?
 
@onready var _bullet_spawn_position := $BulletSpawnPosition2D
@onready var _cooldown_timer := $CooldownTimer
@onready var _range_area := $RangeArea2D
@onready var _animation_player := $AnimationPlayer
@onready var _range_shape: CircleShape2D = $RangeArea2D/Circle2D.shape
@onready var _range_preview: RangePreview = $RangePreview

func _ready():
	# trigger the setter, which also updates the _range_shape
	fire_range = fire_range
	show_range()

func shoot_at(target_position: Vector2):
	look_at(target_position)
	_animation_player.play("shoot")

	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = _bullet_spawn_position.global_position
	
	bullet.fly_to(target_position)
	_cooldown_timer.start(fire_cooldown)
	emit_signal("fired")

func _physics_process(_delta: float):
	# Is weapon ready to shoot?
	if not _cooldown_timer.is_stopped():
		return
		
	if TESTING:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			shoot_at(get_global_mouse_position())
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if _range_preview.modulate.a == 0:
				_range_preview.appear()
			if _range_preview.modulate.a == 1.0:
				_range_preview.disappear()
		return
	
	# Are there any targets in the Area2D? 
	var targets: Array = _range_area.get_overlapping_areas()
	if targets.is_empty():
		return
	
	# Shoot at the first one (TODO: Explore other priorization, like "shoot enemy with most HP")
	var target: Node2D = targets[0]
	shoot_at(target.global_position)
	


func show_range():
	_range_preview.radius = fire_range
	_range_preview.appear()

func hide_range():
	_range_preview.disappear()
