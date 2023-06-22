extends StateMachine

func _ready():
	states_map = {
		"idle": $States/Idle,
		"move": $States/Move,
		"attack": $States/Attack,
	}
	
	# we have to call set_active here or else the physics process wants to do stuff
	set_active(false)

func _change_state(state_name):
	if not _active:
		return
	super(_change_state(state_name))

