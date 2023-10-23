class_name HitBoxArea2D

extends Area2D

enum Teams { PLAYER, ENEMY }
@export var team := Teams.PLAYER

@export var damage := 1
@export var can_hit_multiple := false



func _on_area_entered(area: Area2D):
	apply_hit(area)
	
func apply_hit(hurt_box: HurtBoxArea2D):
	if team == hurt_box.team:
		return
	
	hurt_box.get_hurt(damage)
		
	set_deferred("monitoring", can_hit_multiple)

