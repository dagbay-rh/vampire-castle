extends Node

@onready var player_node = null
@onready var player_max_health = 100
@onready var player_health = 100
@onready var player_position = Vector2.ZERO

signal change_health(value)

var knockbackTween
var engagedEnemies : Array = []
var iframe = false # true if iframe on

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_user_signal("hurt", [{"name": "damage", "type": TYPE_INT}])
	add_user_signal("increase_special", [])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_node:
		player_position = player_node.position
	

func set_player_node(res_path):
	player_node = get_node(res_path)


func set_iframe(iframe_sent):
	iframe = iframe_sent



func take_damage(damage):
	if iframe:
		return
	
	print_debug("Player takes " + str(damage) + " points of damage")
	knockbackTween = get_tree().create_tween()
	knockbackTween.parallel().tween_property(player_node, "knockback", Vector2(0,0), 0.25)
	player_node.modulate = Color(1,0,0,1)
	knockbackTween.parallel().tween_property(player_node, "modulate", Color(1,1,1,1), 0.25)
	player_health -= damage
	# signals the bars.gd script to change the health bar value
	change_health.emit(player_health)
	if player_health <= 0:
		game_over()
	

func gain_health(points):
	if player_health + points > player_max_health:
		player_health = player_max_health
	else:
		player_health += points
	
	change_health.emit(player_health)


func engage_enemy(rid):
	engagedEnemies.append(rid)
	
func disengage_enemy(rid):
	var enemy_rid = engagedEnemies.find(rid)
	engagedEnemies.remove_at(enemy_rid)

# causes the bars.gd script to add special points to the bar
func increase_special():
	emit_signal("increase_special")

func game_over():
	get_tree().paused = true
	SceneSwitch.switch_scene("res://ui/dead.tscn")
	
