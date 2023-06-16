extends Node

@onready var player_node = null

var knockbackTween
var playerNode

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("hurt", [{"name": "damage", "type": TYPE_INT}])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_player_node(res_path):
	playerNode = res_path
	print_debug(playerNode)
	var hitbox_node = get_node(playerNode + "/Hitbox")
	hitbox_node.connect("area_entered", player_take_damage)


func player_take_damage(_area):
	knockbackTween = get_tree().create_tween()
	var player = get_node(playerNode)
	knockbackTween.parallel().tween_property(player, "knockback", Vector2(0,0), 0.25)
	
	player.modulate = Color(1,0,0,1)
	knockbackTween.parallel().tween_property(player, "modulate", Color(1,1,1,1), 0.25)
	emit_signal("hurt", 10)
	
