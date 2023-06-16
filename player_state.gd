extends Node

@onready var player_node = null

signal hurt(damage)

var knockbackTween
var playerNode
var engagedEnemies : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_user_signal("hurt", [{"name": "damage", "type": TYPE_INT}])
	add_user_signal("increase_special", [])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_player_node(res_path):
	playerNode = res_path
	var hitbox_node = get_node(playerNode + "/Hitbox")
	hitbox_node.connect("area_entered", player_take_damage)


func player_take_damage(_area):
	knockbackTween = get_tree().create_tween()
	var player = get_node(playerNode)
	knockbackTween.parallel().tween_property(player, "knockback", Vector2(0,0), 0.25)
	
	player.modulate = Color(1,0,0,1)
	knockbackTween.parallel().tween_property(player, "modulate", Color(1,1,1,1), 0.25)
	hurt.emit(10)

func engage_enemy(rid):
	engagedEnemies.append(rid)
	
func disengage_enemy(rid):
	var enemy_rid = engagedEnemies.find(rid)
	engagedEnemies.remove_at(enemy_rid)
	
func increase_special():
	emit_signal("increase_special")
