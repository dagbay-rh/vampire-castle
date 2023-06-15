extends Node

@onready var player_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("hurt", [{"name": "damage", "type": TYPE_INT}])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_player_node(res_path):
	player_node == load(res_path)
	var hitbox_node = get_node(res_path + "/Hitbox")
	hitbox_node.connect("area_entered", player_take_damage)


func player_take_damage(_area):
	print("weee")
	emit_signal("hurt", 10)
	
