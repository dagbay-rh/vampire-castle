extends RigidBody2D

@onready var player = get_parent().get_node("Belmont")
var thrown = false
var active = false

func _physics_process(delta):
	if not thrown:
		self.position = get_parent().get_node("VillagerMan/Marker2D").global_position

func _input(event):
	# whenever the player enters the area, attack mode
	print("area entered")
	if Input.is_action_pressed("throw"):
		print("throwing!")
		if get_parent().get_node("VillagerMan").sprite.flip_h == false:
			print("in if")
			apply_impulse(Vector2(), Vector2(150, -200))
		else:
			print("in else")
			apply_impulse(Vector2(), Vector2(-150, -200))
		thrown = true
