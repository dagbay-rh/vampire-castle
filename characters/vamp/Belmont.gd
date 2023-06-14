extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_velocity : float = -400.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision : CollisionShape2D = $bodyCollision

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
	
	if Input.is_action_pressed("down"):
		if is_on_floor():
			crouch()
	
	if Input.is_action_just_released("down"):
		if animated_sprite.animation == "crouch":
			animation_locked = false
			animated_sprite.stop()
			animated_sprite.emit_signal("animation_finished")


		
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if not animation_locked:
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
