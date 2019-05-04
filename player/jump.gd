extends "res://scripts/state.gd"

func initialize(obj):
	obj.anim_next = "jump"
	obj.vel.y = -96
	if obj.rotate.scale.x<0:
		obj.vel.x = -110
	else:
		obj.vel.x = 110

func run(obj, delta):
	# gravity
	#obj.vel.y = min(obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	obj.vel.y = obj.vel.y + game.GRAVITY*delta
	# slow down horizontally
	#obj.vel.x *= 0.5
	# move
	#obj.vel = obj.move_and_slide(obj.vel)
	obj.vel = obj.move_and_slide(obj.vel, Vector2(0, -1))
	
	#if obj.is_on_floor():
	#	obj.fsm.state_next = obj.fsm.STATES.idle
		
	