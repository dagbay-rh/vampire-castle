"""
Interface for states. We just want to make sure that we have all the necessary
functions availble in each state so nothing gets called and blows up because
it's not there.

This node is inherited by the states themselves.
"""
extends Node

class_name State

signal finished(next_state_name)

func enter():
	return
	
func exit():
	return
	
func handle_input(event):
	return
	
func update(delta):
	return
	
func _on_animation_finished(anim_name):
	return
