extends State

func enter():
	print_debug("enter_run")
	owner.get_node("AnimationPlayer").play("run_r")
	
func exit(): 
	owner.get_node("AnimationPlayer").stop()
	print_debug("exiting")

func handle_input(event):
	pass
	
"""
update() is basically the physics process function from within the current
state. So anything that would go into _physics_process() would go here
instead
"""
func update(_delta):
	pass
