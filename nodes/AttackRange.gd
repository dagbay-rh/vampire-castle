extends Area2D

class_name AttackRange

signal player_in_range

var player_node 

func _init() -> void:
	collision_layer = 0
	collision_mask = pow(2, 8-1)
	
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	#todo: this shoudl be smarter. Just at est to check we switch back to idle
	self.connect("area_exited", _on_area_exited)

func _on_area_entered(hurtbox: Hurtbox) -> void:
	if hurtbox == null or hurtbox != PlayerState.player_hurtbox:
		pass
	else:
		emit_signal("player_in_range", true)

func _on_area_exited(hurtbox : Hurtbox) -> void:
	if hurtbox == null:
		pass
	else:
		emit_signal("player_in_range", false)
