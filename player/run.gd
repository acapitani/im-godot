extends "res://scripts/state.gd"

func initialize(obj):
	obj.anim_next = "run"

func run(obj, delta):
	if (obj.vel.x>0 or obj.vel.x < 0):
		obj.anim_next = "run"
	
	# gravity
	#obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	obj.vel.y = obj.vel.y + game.GRAVITY*delta
	# move
	#obj.vel = obj.move_and_slide(obj.vel)
	obj.vel = obj.move_and_slide(obj.vel, Vector2(0, -1))
	
	# player input
	var is_moving = false
	if Input.is_action_pressed("btn_left"):
		is_moving = true
		#obj.vel.x = lerp(obj.vel.x, -obj.MAX_VEL, obj.ACCEL * delta)
		obj.vel.x = -96
		obj.rotate.scale.x = -1
	elif Input.is_action_pressed("btn_right"):
		is_moving = true
		#obj.vel.x = lerp(obj.vel.x, obj.MAX_VEL, obj.ACCEL * delta)
		obj.vel.x = 96
		obj.rotate.scale.x = 1
	else:
		obj.vel.x = 0
	if Input.is_action_pressed("btn_jump") and obj.is_on_floor():
		is_moving = true
		obj.fsm.state_next = obj.fsm.STATES.jump
	#else:
		
		#obj.vel.x = lerp(obj.vel.x, 0, obj.DECEL * delta)
		#if abs(obj.vel.x) < 1:
		#	obj.vel.x = 0
		#else:
		#	is_moving = true
	if not is_moving:
		obj.fsm.state_next = obj.fsm.STATES.idle
	
	if obj.check_ground():
		if Input.is_action_just_pressed("btn_jump"):
			pass
			#obj.fsm.state_nxt = obj.fsm.STATES.jump
	else:
		#obj.fsm.state_nxt = obj.fsm.STATES.fall
		pass
