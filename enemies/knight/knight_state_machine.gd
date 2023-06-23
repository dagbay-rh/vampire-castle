extends StateMachine

func _ready():
	add_state("patrol")
	add_state("chase")
	add_state("idle")
	add_state("attack")
	add_state("dead")
	call_deferred("set_state", states[parent.STATE])

func _state_logic(delta):
	
	parent._apply_gravity(delta)
	
	parent._get_player_position()

	if state != states.attack && parent._should_turn():
		parent._turn() 
		
	if state == states.attack:
		parent._attack()

	if state == states.chase:
		parent._chase_player()
	else:
		parent._stop()
	
		
	parent._apply_velocity()
	
func _get_transition(delta):
	match state:
		states.idle:
			if parent._should_chase():
				return states.chase
		states.chase:
			if parent._should_attack():
				return states.attack
		states.attack:
			if parent._should_attack():
				pass
			elif parent._should_chase():
				return states.chase
		states.dead:
			if parent._is_dead():
				set_physics_process(false)
				$Collision.disabled = true
				
func _enter_state(new_state, old_state):
	match new_state:
		states.chase:
			parent.animation_player.play("run")
		states.idle:
			parent.animation_player.play("idle")
		states.attack:
			pass
	
func _exit_state(old_state, new_state):
	pass
