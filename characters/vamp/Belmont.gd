extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	
	$AnimatedSprite2D.connect("animation_finished", on_animated_sprite_2d_finished)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$AnimatedSprite2D.play("jump_flip")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("left") and is_on_floor():
		$AnimatedSprite2D.set_flip_h(true)
		$AnimatedSprite2D.play("running")
		
	if Input.is_action_pressed("right") and is_on_floor():
		$AnimatedSprite2D.set_flip_h(false)
		$AnimatedSprite2D.play("running")
		
	if Input.is_action_pressed("down") and is_on_floor():
		$AnimatedSprite2D.play("crouch")
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func on_animated_sprite_2d_finished():
	$AnimatedSprite2D.play("default")
