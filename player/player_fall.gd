extends "res://scripts/state.gd"

func initialize(obj):
	obj.anim_next = "fall"

func run(obj, delta):
	# gravity
	obj.vel.y = obj.vel.y + game.GRAVITY*delta
	obj.vel = obj.move_and_slide(obj.vel, Vector2(0, -1))
	
	if obj.check_ground():
		obj.fsm.state_next = obj.fsm.STATES.idle
