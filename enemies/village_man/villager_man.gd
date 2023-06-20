extends Enemy

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var fireball_marker : Marker2D = $FireballMarker
@onready var timer : Timer = $CooldownTimer

@export var FIREBALL: PackedScene = preload("res://enemies/village_man/fireball.tscn")

var exists = false
var fireball_limit = 3
var fireball_count = 0

func _physics_process(delta):
	if dead:
		set_physics_process(false)
		return
		
	if not engaged:
		return
		
	var distance = PlayerState.player_position - self.position
	var player_direction = distance.normalized()
		
	if player_direction.x <= 0:
		animated_sprite.flip_h = true
		animated_sprite.position = Vector2(-11, -8)
		fireball_marker.position = Vector2(-11, 0)
	if player_direction.x > 0:
		animated_sprite.flip_h = false
		animated_sprite.position = Vector2(11, -8)
		fireball_marker.position = Vector2(11, 0)
	
	velocity = position.direction_to(PlayerState.player_position) * speed
	
	if attacking:
		velocity.x = 0
	elif distance.x < 20.0:
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
	animated_sprite.animation = "walk"
	animated_sprite.play()

func _on_chase_range_area_exited(_area):
	engaged = false
	if dead:
		queue_free()
	else:
		animated_sprite.animation = "default"
		animated_sprite.play()

func _on_cooldown_timer_timeout():
	if dead:
		return
	
	waiting = false
	attacking = false
	
	attack()
	
func _on_animated_sprite_2d_animation_finished():
	if dead:
		return
	
	animated_sprite.animation = "walk"
	animated_sprite.play()
	
	attacking = false
	
	# start waiting
	waiting = true
	$CooldownTimer.start()

func attack():
	# attack and start timer
	if waiting or fireball_count >= fireball_limit:
		return
	
	if FIREBALL == null:
		# what?
		return
	
	animated_sprite.animation = "attack"
	animated_sprite.play()
	
	attacking = true
	
	# attack hitbox controlled by fireball script
	# instantiate fireball at marker
	var ball = FIREBALL.instantiate()
	add_child(ball)
	ball.global_position = fireball_marker.global_position
	
	var dir = animated_sprite.flip_h # true is left
	ball.get_child(0).flip_h = not dir
	
	# add velocity to ball
	if dir:
		ball.linear_velocity = Vector2(-60, -5)
	else:
		ball.linear_velocity = Vector2(60, -5)
		
	fireball_count += 1
		
func fireball_despawned():
	# fireball despawned can attack again
	if dead or not engaged:
		return
		
	fireball_count -= 1
		
	attack()

func inbetween_attacks():
	pass

func hit():
	animated_sprite.animation = "hurt"
	animated_sprite.play()
	
func death():
	# call the enemy base class's death process to add to special and disengage
	print_debug("enemy dead")
	death_process()
	
	animated_sprite.animation = "death"
	animated_sprite.play()
	
	remove_collisions()
	dead = true
	engaged = false

func remove_collisions():
	# TODO: Figure out the right way to clear the boxes. Disabling didn't work
	remove_child($Hitbox)
	remove_child($CollisionShape2D)
