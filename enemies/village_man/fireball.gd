extends CharacterBody2D

var thrown = false
const speed = 500
@onready var player = get_parent().get_node("Characters").get_node("Belmont")

func _physics_process(delta):
	if not thrown:
		self.position = get_parent().get_node("VillagerMan/Marker2D").global_position
		
	var distance = player.position - self.position
	var player_direction = distance.normalized()
	print("DISTANCE: ")
	print(distance)
	if distance.y > -5 and distance.y < 0: 
		thrown = true
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
	if distance.y == 0:
		self.queue_free()
	print(self.position)
