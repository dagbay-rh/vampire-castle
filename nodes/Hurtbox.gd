extends Area2D

class_name Hurtbox

func _init() -> void:
	collision_layer = pow(2, 8-1)
	collision_mask = pow(2, 8-1)
	
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox : Hitbox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
	
