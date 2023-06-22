extends Area2D

class_name Detectionbox

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
		print_debug("player_entered")
		owner._change_state("move")
	# go get the chase down the player

func _on_area_exited(trigger : Trigger) -> void:
	if trigger == null:
		pass
	else:
		print_debug("player_exited")
		owner._change_state("idle")
