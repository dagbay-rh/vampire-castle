extends Node

@onready var player_node = null
@onready var player_health = 100
@onready var player_position = Vector2.ZERO

signal change_health(value)

var knockbackTween
var engagedEnemies : Array = []

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

	
func take_damage(damage):
	player_health -= damage
	# signals the bars.gd script to change the health bar value
	change_health.emit(player_health)
	if player_health <= 0:
		game_over()


#func player_take_damage(_area):
#	knockbackTween = get_tree().create_tween()
#	var player = get_node(playerNode)
#	knockbackTween.parallel().tween_property(player, "knockback", Vector2(0,0), 0.25)
#
#	player.modulate = Color(1,0,0,1)
#	knockbackTween.parallel().tween_property(player, "modulate", Color(1,1,1,1), 0.25)
#	hurt.emit(10)

func engage_enemy(rid):
	engagedEnemies.append(rid)
	
func disengage_enemy(rid):
	var enemy_rid = engagedEnemies.find(rid)
	engagedEnemies.remove_at(enemy_rid)
	print_debug("enemy " + str(enemy_rid) + " disengaged")

# causes the bars.gd script to add special points to the bar
func increase_special():
	emit_signal("increase_special")

func game_over():
	get_tree().paused = true
	SceneSwitch.switch_scene("res://ui/dead.tscn")
	
