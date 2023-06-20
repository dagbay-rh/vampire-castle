extends CharacterBody2D

@export var pause_input : bool = false

@export var speed_vampire : float = 200.0
@export var jump_velocity : float = -400.0

@export var speed_bat_x : float = 250.0
@export var speed_bat_y : float = 250.0

@export var friction : float = 2000.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision : CollisionShape2D = $bodyCollision
@onready var attack_box : Area2D = $AttackBox
@onready var iframe_timer : Timer = $iFrameTimer

# project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# game state
var animation_locked : bool = false
var is_bat : bool = false
var recently_slid : bool = false
var movement_locked : bool = false
var attacking : bool = false

# inputs
var input : Dictionary = {}

var direction = Vector2.ZERO

# knockback
var knockback : Vector2 = Vector2(0, 0)
var knockbackTween

var attack_anims : Array = [
	"upward_slash",
	"downward_slash",
	"side_slash",
]

func _ready():
	randomize()
	PlayerState.set_player_node(str(self.get_path()))

# All iputs we want to keep track of
func get_input():
	input = {
		# direction
		"direction": Input.get_vector("left", "right", "up", "down"),
		
		# down
		"down": Input.is_action_pressed("down"),
		"just_down": Input.is_action_just_pressed("down"),
		"released_down": Input.is_action_just_released("down"),
		
		# jump
		"jump": Input.is_action_pressed("jump") == true,
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
		
		# transform
		"transform": Input.is_action_pressed("transform"),
		"just_transform": Input.is_action_just_pressed("transform"),
		"released_transform": Input.is_action_just_released("transform"),
		
		# slide
		"slide": Input.is_action_pressed("slide"),
		"just_slide": Input.is_action_just_pressed("slide"),
		"released_slide": Input.is_action_just_released("slide"),
		
		#attack
		"attack": Input.is_action_pressed("attack"),
		"just_attack": Input.is_action_just_pressed("attack"),
		"released_attack": Input.is_action_just_released("attack"),
	}
	
	return input["direction"]


func _physics_process(delta):
	if pause_input:
		return
	
	direction = get_input()
	
	if is_bat:
		physics_process_bat(delta)
	else:
		physics_process_vampire(delta)

	move_and_slide()
	update_animation()
	update_facing_direction()


func physics_process_vampire(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if input["just_jump"] and is_on_floor():
		jump()
	
	if input["down"] and is_on_floor():
		crouch()
	
	if input["just_transform"]:
		bat_transform()
		
	if input["just_slide"] and is_on_floor() and recently_slid == false:
		slide()
		
	if input["just_attack"] and is_on_floor():
		attack()
		
	if input["released_slide"]:
		if animated_sprite.animation == "slide":
			animated_sprite.stop()
			animated_sprite.emit_signal("animation_finished")
	
	if input["released_down"]:
		if animated_sprite.animation == "crouch":
			animated_sprite.stop()
			animated_sprite.emit_signal("animation_finished")
	
	velocity.x += knockback.x
	velocity.y += knockback.y
	knockback = Vector2.ZERO
	
	if direction:
		velocity.x = direction.x * speed_vampire

	velocity.x = move_toward(velocity.x, 0, friction * delta)

func physics_process_bat(delta):
	if input["just_transform"]:
		vampire_transform()
	
	if direction:
		velocity.x = direction.x * speed_bat_x  + knockback.x
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.y = move_toward(velocity.y, 0, friction * delta)


func update_animation():
	if not animation_locked:
		if is_bat:
			return # no op, let idle animation play
		if not is_on_floor():
			animated_sprite.play("jump_flip")
		else:
			if direction.x != 0:
				animated_sprite.play("running")
			else:
				animated_sprite.play("default")


func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		attack_box.position.x = 17
	elif direction.x < 0:
		animated_sprite.flip_h = true
		attack_box.position.x = -17


func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_flip")
	animation_locked = true


func crouch():
	if direction.x == 0:
		update_collision_shape()
		animated_sprite.play("crouch")
		animation_locked = true
		
func slide():
	if direction.x != 0:
		update_collision_shape()
		animated_sprite.play("slide")
		animation_locked = true
		
func attack():
	if not is_on_floor():
		return
	
	attacking = true
	var random_anim = randi() % len(attack_anims)
	direction.x = 0
	movement_locked = true
	animated_sprite.play(attack_anims[random_anim])
	
	attack_box.get_child(0).disabled = false
	attack_box.monitoring = true
	attack_box.monitorable = true
	animation_locked = true


func bat_transform():
	is_bat = true
	animated_sprite.scale.x = 0.115
	animated_sprite.scale.y = 0.115
	animated_sprite.position.x = 1.5
	animated_sprite.position.y = -1.5
	animated_sprite.play("bat_idle")
	animation_locked = false


func vampire_transform():
	is_bat = false
	animated_sprite.scale.x = 1
	animated_sprite.scale.y = 1
	animated_sprite.position.x = 0
	animated_sprite.position.y = 0
	animated_sprite.play("default")
	animation_locked = false


func update_collision_shape():
	if animated_sprite.animation == "crouch":
		body_collision.shape.height = 18
		body_collision.position.y = 8


func reset_collision_shape():
		body_collision.shape.height = 30
		body_collision.position.y = 2.5


func _on_animated_sprite_2d_finished():
	if(animated_sprite.animation in ["upward_slash", "downward_slash", "side_slash"]):
		animation_locked = false
		movement_locked = false
		attack_box.get_child(0).disabled = true
		attack_box.monitoring = false
		attack_box.monitorable = false
	if(animated_sprite.animation == "jump_flip"):
		animation_locked = false
	if(animated_sprite.animation == "crouch"):
		reset_collision_shape()
		animation_locked = false

	if(animated_sprite.animation == "slide"):
		reset_collision_shape()
		recently_slid = true
		$Timer.wait_time = 1
		$Timer.start()
		animation_locked = false
	

func _on_timer_timeout():
	recently_slid = false # Replace with function body.


func _on_hitbox_area_entered(area):
	print_debug("knocked_back")
	var dir_x = position.x - area.position.x
	var dir_y = position.y - area.position.y
	
	var dir = Vector2(dir_x, dir_y).normalized()
	
	knockback = dir * 350
	
	PlayerState.set_iframe(true)
	iframe_timer.start()


func _on_i_frame_timer_timeout():
	# reset iframe value to false
	PlayerState.set_iframe(false)
