extends Area2D

class_name Detectionbox

func _init() -> void:
	collision_layer = 0
	collision_mask = pow(2, 2-1)
	
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	
func _on_area_entered(trigger : Trigger) -> void:
	if trigger == null:
		pass
	else:
		print_debug("player_entered")
	# go get the chase down the player
	
