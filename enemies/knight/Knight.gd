extends CharacterBody2D

@onready var player = get_parent().get_node("Belmont")
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $AttackTimer
@onready var hitbox : Area2D = $Hitbox

const speed = 30

# project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var active = false
var dead = false
var attacking = false
var health = 3

func _ready():
	hitbox.monitoring = false
	hitbox.get_child(0).disabled = true

func _physics_process(delta):
	if dead:
		set_physics_process(false)
		return
	
	if active and player:
		var distance = player.position - self.position
		var player_direction = distance.normalized()
		
		if player_direction.x <= 0:
			sprite.flip_h = true
			hitbox.transform.origin = Vector2(-55.0, 20.0)
		if player_direction.x > 0:
			sprite.flip_h = false
			hitbox.transform.origin = Vector2(2.0, 20.0)
			
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
	if active:
		# ignore, already active
		return
	
	active = true
	sprite.animation = "run"
	sprite.play()

func _on_stop_area_exited(_area):
	active = false
	if dead:
		queue_free()
	else:
		sprite.animation = "default"
	
func _on_attack_timer_timeout():
	attacking = false

func _on_hitbox_area_entered(_area):
	# player takes damage
	print("take damage")
	
func _on_hurtbox_area_entered(_area):
	# take damage
	health -= 1
	if health <= 0:
		death()

func _on_animated_sprite_2d_animation_finished():
	if dead:
		return
	
	sprite.animation = "run"
	sprite.play()
	attacking = false
	
	hitbox.monitoring = false
	hitbox.get_child(0).disabled = true

func attack():
	# attack and start timer
	sprite.animation = "attack"
	sprite.play()
	timer.start()
	
	attacking = true
	hitbox.monitoring = true
	hitbox.get_child(0).disabled = false
	
func death():
	sprite.animation = "death"
	sprite.play()
	dead = true
	active = false
