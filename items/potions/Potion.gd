extends Area2D


func _on_area_entered(_area):
	# bump the players health
	PlayerState.gain_health(20)
	
	# remove self
	queue_free()
