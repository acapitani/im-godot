extends "res://scripts/state.gd"

func initialize(obj):
	obj.anim_next = "idle"

func run(obj, delta):
	if obj.lift==null or obj.lift.moving==false:
		obj.fsm.state_next = obj.fsm.STATES.idle
	
		
	