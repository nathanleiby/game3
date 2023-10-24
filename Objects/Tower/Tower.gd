class_name Tower
extends Node2D

signal sold(price, place)
signal selected(selected)

@export var cost := 100


# hacky syntax to get type enforcement (: <type>) + autocompletion (as <type>) (https://stackoverflow.com/a/76973611)
@onready var _weapon: Weapon2D = $Weapon2D as Weapon2D 
@onready var _interface: UIUnit = $Interface as UIUnit
@onready var _cooldown_bar: UICooldownBar = $UICooldownBar as UICooldownBar
@onready var _selection: SelectableArea2D = $SelectableArea2D as SelectableArea2D

func _ready():
	_weapon.show_range()
	
func show_interface():
	_weapon.show_range()
	_interface.appear()

func hide_interface():
	_weapon.hide_range()
	_interface.disappear()


func _on_selectable_area_2d_selection_changed(selected):
	if selected:
		show_interface()
	else:
		hide_interface()
	emit_signal("selected", selected)


func _on_sell_button_pressed():
	emit_signal("sold", cost / 2 , position)
	queue_free()


func _on_weapon_2d_fired():
	_cooldown_bar.start(_weapon.fire_cooldown)
