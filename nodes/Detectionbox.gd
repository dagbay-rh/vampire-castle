extends Area2D

class_name Detectionbox

signal player_detected

func _init() -> void:
	collision_layer = 0
	collision_mask = pow(2, 2-1)
	
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	#todo: this shoudl be smarter. Just at est to check we switch back to idle
	self.connect("area_exited", _on_area_exited)
	
func _on_area_entered(trigger : Trigger) -> void:
	if trigger == null:
		pass
	else:
		emit_signal("player_detected", true)

func _on_area_exited(trigger : Trigger) -> void:
	if trigger == null:
		pass
	else:
		emit_signal("player_detected", false)
