extends Area2D

class_name Hitbox

@export var damage : int = 10

func _init() -> void:
	collision_layer = pow(2, 8-1)
	collision_mask = 0
	

