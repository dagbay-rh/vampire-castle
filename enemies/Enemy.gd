extends CharacterBody2D

class_name NewEnemy

@export var hit_points : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage : int) -> void:
	print_debug("took " + str(damage) + " points of damage")
