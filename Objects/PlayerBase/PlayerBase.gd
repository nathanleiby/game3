extends Node2D

signal destroyed

@export var max_health := 10

# I learned in "Godot in 24h" book (Godot 3.x) we do this for perf reasons .. cheaper to do this setup once vs lookup at runtime
@onready var _sprites := $Sprites
@onready var _interface := $Interface
@onready var _ui_health_bar := $Interface/HealthBar
@onready var _health_bar := $HealthBar
@onready var _hurt_box := $HurtBoxArea2D

var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		_ui_health_bar.value = health
		
		if health < 1:
			_destroy()
	get:
		return health

func _ready():
	health = max_health
	
	_ui_health_bar.share(_health_bar) # keeps them in sync (Godot wizardry for Ranges like ProgressBars)
	_ui_health_bar.max_value = max_health
	_ui_health_bar.value = health
	
# TODO: signal parameter types (damage: int) don't seem to be available in editor or generated methods
func _on_hurt_box_area_2d_hit_landed(damage):
	health = health - damage



func _on_selectable_area_2d_selection_changed(selected):
	# If tower is selected while it is being damaged,
	# the two health bars $Interface/HealthBar and $HealthBar will overlap  
	if selected:
		_interface.appear()
	else:
		_interface.disappear()

func _destroy():
	emit_signal("destroyed")
	_sprites.play("Explode") # beware: case-sensitive animation names
	_hurt_box.set_deferred("monitorable", false) # `set_deferred(...)` is sugar for `call_deferred(set, ...)` .. I miss `defer` keyword in Golang! it's so nice. I guess it's roughly sugar for these too?
	
	
	
	

