class_name HurtBoxArea2D
extends Area2D

## Emitted when receiving a hit
signal hit_landed(damage: int)

enum Teams { PLAYER, ENEMY } # TODO: How to make this a shared enum vs re-written in two classes?
@export var team := Teams.PLAYER

## Armor reduces incoming damage
@export var armor := 0

## Called by `HitBoxArea2D` when it interacts with this hurt box
func get_hurt(damage: int):
	var final_damage := damage - armor
	emit_signal("hit_landed", final_damage)
	
