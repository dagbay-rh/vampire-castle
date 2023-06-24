extends CharacterBody2D

@export var SPEED : float = 30
@export var STATE : String = "idle"
@export var HP : int = 30

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var detectionbox : Detectionbox = $Detectionbox
@onready var attackrange : AttackRange = $Node2D/Sprite2D/AttackRange
@onready var hurtbox : Hurtbox = $Node2D/Sprite2D/Hurtbox
@onready var hitbox : Hitbox = $Node2D/Sprite2D/Hitbox
@onready var knight : CharacterBody2D = self
@onready var attack_delay : Timer = $AttackDelay

var distance : Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_detected : bool
var player_in_range : bool
var player_direction : Vector2
var turned : bool
var attacks : Array
var attack_to_play : int
var attack_delayed : bool
var dead : bool

func _ready():
	randomize()
	attacks = ["attack_one", "attack_two"]
	detectionbox.connect("player_detected", _set_chase)
	attackrange.connect("player_in_range", _set_attack)
	attack_delay.connect("timeout", _on_timer_timeout)
	animation_player.connect("animation_finished", _on_animation_finished)
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
func _apply_velocity():
	velocity = position.direction_to(PlayerState.player_position) * SPEED

func _get_player_position():
	distance = PlayerState.player_position - self.position
	player_direction = distance.normalized()
		
func _chase_player():
	if player_in_range:
		pass
	else:
		move_and_slide()
	
func _turn():
	if not turned:
		turned = true
		self.apply_scale(Vector2(-1, 1))
	elif turned:
		turned = false
		self.apply_scale(Vector2(-1, 1))
		
		
func _stop():
	pass
		
func _attack():
	if abs(distance.x) < 60.0:
		if attack_delayed:
			pass
		else:
			animation_player.play(attacks[attack_to_play])
	pass
	
func _attack_to_play() -> void:
	attack_to_play = randi() % len(attacks)
	
func _should_turn() -> bool:
	if player_direction.x <= -0.1 and not turned:
		return true
	elif player_direction.x > -0.1 and turned:
		return true
	else:
		return false
		
func _should_chase() -> bool:
	return player_detected
	
func _should_patrol():
	pass
	
func _should_attack() -> bool:
	return player_in_range
	
func _is_dead() -> bool:
	return dead
	
func _should_idle():
	pass

func take_damage(damage):
	HP -= damage
	if HP <= 0:
		animation_player.play("die")
		dead = true
		
	
func _set_chase(value):
	player_detected = value

func _set_attack(value):
	player_in_range = value
	
func _on_animation_finished(anim_name):
	attack_delay.start()
	attack_delayed = true
	if anim_name in ["attack_two", "attack_one"]:
		_attack_to_play()
		
func _on_timer_timeout():
	attack_delayed = false
