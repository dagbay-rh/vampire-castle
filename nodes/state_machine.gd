# Pull this state machine out of this chunk of code to mess around
# https://github.com/GDQuest/godot-demos/blob/master/2018/04-24-finite-state-machine/player_v2/state_machine.gd

extends Node

class_name StateMachine

signal state_changed(current_state)

@export var START_STATE : String = ""
var states_map = {}
var current_state = null
@onready var _active = false : set = set_active, get = get_active

func _ready():
	for child in get_children():
		child.connect("finished", _change_state)
	initialize(START_STATE)
	
func initialize(start_state):
	set_active(true)
	current_state = states_map[start_state]
	current_state.enter()

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	print_debug("set active")
	if not _active:
		current_state = null

func get_active():
	return _active

func _input(event):
	current_state.handle_input(event)
	
func _physics_process(delta):
	current_state.update(delta)
	
func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	emit_signal("state_changed", current_state)
	
	current_state.enter()
