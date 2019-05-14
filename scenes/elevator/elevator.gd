extends "res://scenes/scene.gd"

enum STATES {WAIT, MOVE}

var state = STATES.WAIT
var player_on_lift = false
var moving = false
var floors = []
var current_floor = 0
var target_floor = -1
const NUM_FLOORS = 12

onready var map = $map
onready var top = $lift/top
onready var bottom = $lift/bottom

# Called when the node enters the scene tree for the first time.
func _ready():
	game.gamestate.current_scene = "res://scenes/elevator/elevator.tscn"
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	match state:
		STATES.WAIT:
			moving = false
		STATES.MOVE:
			var tposy = 0-(target_floor*128)
			var posy = map.position.y
			var on_floor = false
			if current_floor>target_floor and map.position.y>=tposy:
				on_floor = true
			elif current_floor<target_floor and map.position.y<=tposy:
				on_floor = true
			if on_floor:
				map.position.y = tposy
				state = STATES.WAIT
				current_floor = target_floor

func move_up():
	if state==STATES.WAIT:
		if current_floor>0:
			target_floor = current_floor-1
			_moving(Vector2(map.global_position.x, map.global_position.y+128))
	return moving
	
func move_down():
	if state==STATES.WAIT:
		if current_floor<(NUM_FLOORS-1):
			target_floor = current_floor+1
			_moving(Vector2(map.global_position.x, map.global_position.y-128))
	return moving
	
func _moving(targetpos):
	state = STATES.MOVE
	moving = true
	$tween.interpolate_property(map, "position", map.global_position, targetpos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.interpolate_property(top, "position", top.global_position, targetpos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.interpolate_property(bottom, "position", bottom.global_position, targetpos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	
func _on_lift_trigger_area_entered(area):
	if game.player==null or area.get_parent()!=game.player:
		return
	if player_on_lift:
		return
	player_on_lift = true
	game.player.lift = self
	print("player on lift")
	
func _on_lift_trigger_area_exited(area):
	if moving:
		return
	if game.player==null or area.get_parent()!=game.player:
		return
	if player_on_lift:
		player_on_lift = false
		game.player.lift = null
		print("player out of lift")


func _on_player_exit_left():
	emit_signal("next_scene", "res://scenes/test_room.tscn")


func _on_player_exit_right():
	emit_signal("next_scene", "res://scenes/test_room.tscn")
