extends RigidBody2D

@onready var villager = get_parent()


func _on_floor_area_entered(_area):
	# when the fireball reaches the floor
	print("floor")
	$Timer.start()
	self.freeze = true # otherwise it will move relative to the villager


func _on_timer_timeout():
	# alert the villager; remove fireball at the end of the timer
	villager.fireball_despawned()
	
	queue_free()


func _on_hurting_box_area_entered(area):
	# damage player
	print("hurt")
	PlayerState.take_damage(10)
