extends CharacterBody2D

class_name Enemy

# required for enemy to impact the play
@onready var attackBox : Area2D = $AttackBox
@onready var hitBox : Area2D = $Hitbox
@onready var rid : int = get_rid().get_id()
@onready var player = get_parent().get_node("Belmont")

# configurable params per enemy
@export var hit_points : int = 3
@export var attack_power : int = 10
@export var speed : int = 30
@export var attack_delay : float = 2.0


# gravity derived from project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# required booleans to determine enemy state
var dead : bool = false
var engaged : bool = false
var attacking : bool = false

func _ready():
	attackBox.monitoring = false
	attackBox.get_child(0).disabled = true


func death_process():
	PlayerState.increase_special()
	PlayerState.disengage_enemy(rid)

func _on_hitbox_area_entered(_area):
	if dead:
		return
	hit_points -= 1
	if hit_points <= 0:
		death()
		
func _on_attack_timer_timeout():
	print_debug("called timeout")
	attacking = false
		
func death():
	# override this func with subclass death
	pass
