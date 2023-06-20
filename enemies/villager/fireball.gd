extends RigidBody2D

var parent_name = "VillagerMan"
@onready var villager = get_parent().find_child(parent_name)


func _on_floor_area_entered(_area):
	# when the fireball reaches the floor
	$Timer.start()
	self.freeze = true # otherwise it will move relative to the villager


func _on_timer_timeout():
	# alert the villager; remove fireball at the end of the timer
	# villager.fireball_despawned()
	
	queue_free()


func _on_hurting_box_area_entered(_area):
	# damage player
	PlayerState.take_damage(10)
