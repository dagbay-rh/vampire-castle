extends CharacterBody2D


@export var speed_vampire : float = 200.0
@export var jump_velocity : float = -400.0

@export var speed_bat_x : float = 250.0
@export var speed_bat_y : float = 250.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision : CollisionShape2D = $bodyCollision

# project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# game state
var animation_locked : bool = false
var is_bat : bool = false

# inputs
var input : Dictionary = {}
var direction : Vector2 = Vector2.ZERO


func _ready():
	pass


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
		"released_transform": Input.is_action_just_released("transform")
	}
	
	direction = input["direction"]


func _physics_process(delta):
	get_input()
	
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
	
	if input["released_down"]:
		if animated_sprite.animation == "crouch":
			animated_sprite.stop()
			animated_sprite.emit_signal("animation_finished")

	if direction:
		velocity.x = direction.x * speed_vampire
	else:
		velocity.x = move_toward(velocity.x, 0, speed_vampire)


func physics_process_bat(delta):
	if input["just_transform"]:
		vampire_transform()
	
	if direction:
		velocity.x = direction.x * speed_bat_x
		velocity.y = direction.y * speed_bat_y
	else:
		velocity.x = move_toward(velocity.x, 0, speed_bat_x)
		velocity.y = move_toward(velocity.y, 0, speed_bat_y)


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
	elif direction.x < 0:
		animated_sprite.flip_h = true


func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_flip")
	animation_locked = true


func crouch():
	if direction.x == 0:
		update_collision_shape()
		animated_sprite.play("crouch")
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
	if(animated_sprite.animation == "jump_flip"):
		animation_locked = false
	if(animated_sprite.animation == "crouch"):
		reset_collision_shape()
		animation_locked = false
