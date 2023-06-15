extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("max_reached", [{"value": 100}])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.value == self.max_value:
		emit_signal("max_reached")
