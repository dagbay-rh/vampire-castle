extends Enemy

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $AttackTimer


func _physics_process(delta):
	if dead:
		set_physics_process(false)
		return
	
	if not engaged:
		return
	
	var distance = PlayerState.player_position - self.position
	var player_direction = distance.normalized()
	
	if not attacking:
		if player_direction.x <= -0.1: # offset so the knight turns when the characters is right behind him
			animated_sprite.flip_h = true
			attackBox.transform.origin = Vector2(-32.0, 44.0)
		if player_direction.x > -0.1:
			animated_sprite.flip_h = false
			attackBox.transform.origin = Vector2(22.0, 44.0)
		
	velocity = position.direction_to(PlayerState.player_position) * speed
	
	var dis_x = abs(distance.x)
	if attacking:
		velocity.x = 0
	elif dis_x < 60.0 and not waiting:
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
		
	if dead:
		return # literally dead
	PlayerState.engage_enemy(rid)
	engaged = true
	animated_sprite.animation = "run"
	animated_sprite.play()

func _on_chase_range_area_exited(_area):
	engaged = false
	if dead:
		queue_free()
	else:
		animated_sprite.animation = "default"
		animated_sprite.play()

func _on_attackbox_area_entered(_area):
	# attack power is derived from a property on the Enemy object
	PlayerState.take_damage(attack_power)
	print_debug("take" + str(attack_power) + "damage")

func _on_attack_timer_timeout():
	attacking = false
	waiting = true
	
	if dead:
		return
	
	animated_sprite.animation = "default"
	animated_sprite.play()

func _on_cooldown_timer_timeout():
	if dead:
		return
	
	waiting = false
	
	attack()
	
func _on_animated_sprite_2d_animation_finished():
	if dead:
		return
	
	animated_sprite.animation = "run"
	animated_sprite.play()
	
	attacking = false
	
	# start waiting
	waiting = true
	$CooldownTimer.start()
	
	attackBox.monitoring = false
	attackBox.monitorable = false
	attackBox.get_child(0).disabled = true

func attack():
	# attack and start timer
	animated_sprite.animation = "attack"
	animated_sprite.play()
	timer.start()
	
	attacking = true
	attackBox.monitoring = true
	attackBox.monitorable = true
	attackBox.get_child(0).disabled = false
	
func inbetween_attacks():
	pass
	
func hit():
	animated_sprite.animation = "hit"
	animated_sprite.play()
	
func death():
	# call the enemy base class's death process to add to special and disengage
	print_debug("enemy dead")
	death_process()
	
	animated_sprite.animation = "death"
	animated_sprite.play()
	
	remove_child(attackBox)
	remove_collisions()
	dead = true
	engaged = false

func remove_collisions():
	# TODO: Figure out the right way to clear the boxes. Disabling didn't work
	remove_child($Hitbox)
	remove_child($KnightBody)
