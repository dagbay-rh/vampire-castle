extends Enemy

@export var patrol_direction : Node2D

@onready var animated_sprite : AnimatedSprite2D = $SlimeSprite

func _physics_process(delta):
	
	if dead:
		set_physics_process(false)
		return
	
	var distance = PlayerState.player_position - self.position
	var player_direction = distance.normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not engaged:
		velocity.x = patrol_direction.direction.x * speed
		if patrol_direction.direction.x <= 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity.x = position.direction_to(PlayerState.player_position).x * speed
		if player_direction.x <= 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	
	move_and_slide()

# override base ready function since we'll always be monitoring our attackbox
func _ready():
	pass


func _on_aggro_range_area_entered(_area):
	if engaged:
		return #already fighting
	
	if dead:
		return # literally dead

	PlayerState.engage_enemy(rid)
	engaged = true
	animated_sprite.animation = "move"
	animated_sprite.play()
		
func _on_hitbox_area_entered(_area):
	if dead:
		return
	animated_sprite.animation = "hurt"
	animated_sprite.play()
	hit_points -= 1
	if hit_points <= 0:
		death()
	

func death():
	death_process()
	engaged = false
	dead = true
	remove_collisions()
	animated_sprite.animation = "die"
	animated_sprite.play()

func remove_collisions():
	# TODO: Figure out the right way to clear the boxes. Disabling didn't work
	remove_child($Hitbox)
	remove_child($SlimeBody)


func _on_attack_box_area_entered(area):
	PlayerState.take_damage(attack_power)
