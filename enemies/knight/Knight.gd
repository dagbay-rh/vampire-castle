extends Enemy

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $AttackTimer


func _physics_process(delta):
	if dead:
		set_physics_process(false)
		return
	
	if engaged and player:
		var distance = player.position - self.position
		var player_direction = distance.normalized()
		
		if not attacking:
			if player_direction.x <= 0:
				animated_sprite.flip_h = true
				attackBox.transform.origin = Vector2(-35.0, 41.0)
			if player_direction.x > 0:
				animated_sprite.flip_h = false
				attackBox.transform.origin = Vector2(11.0, 38.0)
			
		velocity = position.direction_to(player.position) * speed
		
		var dis_x = abs(distance.x)
		if attacking:
			velocity.x = 0
		elif dis_x < 60.0:
			print(dis_x)
			velocity.x = 0
			attack()
			
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0
		
		move_and_slide()

func _on_trigger_area_entered(_area):
	# whenever the player enters the area, attack mode
	if engaged:
		# ignore, already active
		return
	PlayerState.engage_enemy(rid)
	engaged = true
	animated_sprite.play("run")

func _on_chase_range_area_exited(_area):
	engaged = false
	if dead:
		queue_free()
	else:
		animated_sprite.animation = "default"
	
func _on_attack_timer_timeout():
	attacking = false

func _on_attackbox_area_entered(_area):
	# attack power is derived from a property on the Enemy object
	PlayerState.take_damage(attack_power)
	print_debug("take" + str(attack_power) + "damage")

func _on_animated_animated_sprite_2d_animation_finished():
	if dead:
		return
	
	animated_sprite.play("run")
	attacking = false
	
	attackBox.monitoring = false
	attackBox.get_child(0).disabled = true

func attack():
	# attack and start timer
	animated_sprite.play("attack")
	timer.start()
	
	attacking = true
	attackBox.monitoring = true
	attackBox.get_child(0).disabled = false
	
func death():
	# call the enemy base class's death process to add to special and disengage
	print_debug("enemy dead")
	death_process()
	animated_sprite.play("death")
	remove_child(attackBox)
	remove_collisions()
	dead = true
	engaged = false

func remove_collisions():
	# TODO: Figure out the right way to clear the boxes. Disabling didn't work
	remove_child($Hitbox)
	remove_child($KnightBody)
