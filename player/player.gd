extends KinematicBody2D

signal player_dead

const MAX_VEL_AIR = 100
const ACCEL_AIR = 5
const DECEL_AIR = 5
const MAX_VEL = 120
const ACCEL = 15
const DECEL = 25
const JUMP_VEL = 110
const JUMP_GRAVITY = 256
const JUMP_MAXTIME = 0.25
const JUMP_MARGIN = 0.1
const AIM_VEL = 10#5

var invulnerable = false#true# 

var fsm = null

var vel = Vector2()
var vel_platform = Vector2()
var dir_cur = 1
var is_jump = false
var anim_current = ""
var anim_next = ""

var is_cutscene = false
var interact_area = null

var is_hit = false

var camera_mode = 0

onready var rotate = $rotate

func _ready():
	# register with game
	game.player = self
	# Initialize states machine
	fsm = preload("res://scripts/fsm.gd").new(self, $states, $states/idle, false)

func set_cutscene():
	is_cutscene = true
	
func reset_cutscene():
	is_cutscene = false

func _physics_process(delta):
	if is_cutscene:
		pass
	else:
		# update states machine
		fsm.run_machine(delta)
		# direction
		#if vel.x > 0:
		#	dir_cur = 1
		#	rotate.scale.x = 1
		#elif vel.x < 0:
		#	dir_cur = -1
		#	rotate.scale.x = -1
		# update animations
		if anim_next != anim_current:
			anim_current = anim_next
			$anim.play(anim_current)
		# interact
		#_interact( delta )
		# platform
		_platform( delta )

#func _process(delta):
#	_aim_weapon( delta )

func check_ground():
	if $down_left.is_colliding() or $down_right.is_colliding():
		return true
	return false

func _interact( delta ):
	if fsm.state_cur == fsm.STATES.interact: 
		return
	if Input.is_action_just_pressed("btn_up"):
		interact_area = _check_interaction()
		if interact_area == null: 
			return
		print( "Player interacting with area ", interact_area.name )
		interact_area.interact(self)

func _check_interaction():
	var areas = $interact_box.get_overlapping_areas()
	print("Interacting areas: ", areas)
	for a in areas:
		if a.has_method("interact"):
			return a
		elif a.get_parent().has_method("interact"):
			return a.get_parent()
	return null


var is_on_platform = false
var old_motion = Vector2()
func _platform( delta ):
	var platform = null
	if $down_left.is_colliding() and $down_left.get_collider() != null and \
		$down_left.get_collider().is_in_group( "platform" ):
			platform = $down_left.get_collider()
	elif $down_right.is_colliding() and $down_right.get_collider() != null and \
		$down_right.get_collider().is_in_group( "platform" ):
			platform = $down_right.get_collider()
	if platform == null:
		camera_mode = 0
		if is_on_platform:
			is_on_platform = false
			vel += vel_platform#old_motion / delta
		vel_platform *= 0.0
		return
	is_on_platform = true
	old_motion = platform.delta_motion
	position += platform.delta_motion
	vel_platform = platform.delta_motion / delta
	camera_mode = 1
	
func _on_hitbox_area_entered( area ):
	if invulnerable: 
		return
	if fsm.state_cur == fsm.STATES.hit or \
		fsm.state_nxt == fsm.STATES.hit:
			return
	fsm.state_nxt = fsm.STATES.hit
	pass # replace with function body

func jump_finished():
	fsm.state_next = fsm.STATES.idle
	if is_on_floor():
		vel.x = 0

#========================
# SFX
#========================
func step():
	#$mplayer.mplay( preload( "res://sfx/step.wav" ) )
	pass

func deadfx():
	#$mplayer.mplay( preload( "res://sfx/player_dead.wav" ), false )
	pass












