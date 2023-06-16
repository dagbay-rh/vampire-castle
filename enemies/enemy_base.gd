extends CharacterBody2D

class_name Enemy

@onready var hitbox : Area2D = $Hitbox
@onready var rid : int = get_rid().get_id()

@export var hit_points : int = 3

func _ready():
	hitbox.monitoring = false
	hitbox.get_child(0).disabled = true

func death_process():
	PlayerState.increase_special()
	PlayerState.disengage_enemy(rid)
