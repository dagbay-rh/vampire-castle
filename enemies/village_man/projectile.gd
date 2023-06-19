extends RigidBody2D

@onready var player = get_parent().get_node("Characters").get_node("Belmont")
var thrown = false
var active = false

func _physics_process(delta):
	if not thrown:
		self.position = get_parent().get_node("VillagerMan/Marker2D").global_position
	print(self.position)

func _input(event):
	# whenever the player enters the area, attack mode
	print("area entered")
	if Input.is_action_pressed("throw"):
		print("throwing!")
		
		if get_parent().get_node("VillagerMan").sprite.flip_h == false:
			print("in if")
			print(self.position)
			apply_impulse(Vector2(), Vector2(1,-2))
			# apply_impulse(Vector2(0.1, 0), Vector2())
		else:
			print("in else")
			apply_impulse(Vector2(), Vector2(-1,-2))
			# apply_impulse(Vector2(-0.1, 0), Vector2())
		thrown = true
