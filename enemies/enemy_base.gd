extends CharacterBody2D

class_name Enemy

# required for enemy to impact the play
@onready var attackBox : Area2D # not all enemies will need this
@onready var rid : int = get_rid().get_id()

# configurable params per enemy
@export var ranged : bool = false
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
var waiting : bool = false


enum DIRECTION {
	LEFT,
	RIGHT
}

var dir = DIRECTION.LEFT


func _ready():
	if not ranged:
		attackBox = $AttackBox
		attackBox.monitoring = false
		attackBox.get_child(0).disabled = true


func death_process():
	PlayerState.increase_special()
	PlayerState.disengage_enemy(rid)


func _on_hitbox_area_entered(_area):
	if dead:
		return
		
	# use hurt animation
	hit()
	hit_points -= 1
	if hit_points <= 0:
		death()

		
func hit():
	# override this func with hit animation
	pass

	
func death():
	# override this func with subclass death
	pass
