extends "res://scripts/state.gd"

func initialize(obj):
	obj.anim_next = "idle"

func run(obj, delta):
	obj.vel.x = 0
	# gravity
	#obj.vel.y = min(obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	obj.vel.y = obj.vel.y + game.GRAVITY*delta
	# slow down horizontally
	#obj.vel.x *= 0.5
	# move
	#obj.vel = obj.move_and_slide(obj.vel)
	obj.vel = obj.move_and_slide(obj.vel, Vector2(0, -1))
	
	# player input
	if Input.is_action_pressed("btn_left") or Input.is_action_pressed("btn_right"):
		obj.fsm.state_next = obj.fsm.STATES.run
	elif Input.is_action_pressed("btn_jump") and obj.is_on_floor():
		obj.fsm.state_next = obj.fsm.STATES.jump
	
	if obj.check_ground():
		pass
		#if Input.is_action_just_pressed("btn_jump") and not obj.is_jump:
		#	obj.fsm.state_nxt = obj.fsm.STATES.jump
	else:
		pass
		#obj.fsm.state_nxt = obj.fsm.STATES.fall
