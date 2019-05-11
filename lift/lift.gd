extends KinematicBody2D

enum STATES {WAIT, MOVE}

var state = STATES.WAIT
var player_on_lift = false
var moving = false
var floors = []
var current_floor = -1
var target_floor = -1

#signal moving(lift, targetpos)

func _set_floors():
	var pos = global_position
	for i in range(1, 5):
		var f = find_node("floor" + str(i))
		if f==null:
			break
		if pos.y>f.global_position.y and current_floor==-1:
			current_floor = floors.size()
			floors.append(pos.y)
		floors.append(f.global_position.y)
	if current_floor==-1:
		floors.append(pos.y)
		current_floor = floors.size()-1 

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_set_floors")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	match state:
		STATES.WAIT:
			moving = false
		STATES.MOVE:
			#var target_pos = Vector2()
			#target_pos.x = global_position.x
			#target_pos.y = floors[target_floor]
			#var desired_vel = target_pos - global_position
			#vel += desired_vel
			#vel = vel.clamped( MAX_VEL )
			#position += vel * delta
			var tposy = floors[target_floor]
			var on_floor = false
			if current_floor<target_floor and position.y<=tposy:
				on_floor = true
			elif current_floor>target_floor and position.y>=tposy:
				on_floor = true
			if on_floor:
				position.y = tposy
				state = STATES.WAIT
				current_floor = target_floor

func move_up():
	if state==STATES.WAIT:
		if current_floor<(floors.size()-1):
			target_floor = current_floor+1
			_moving(Vector2(global_position.x, floors[target_floor]))
	return moving
	
func move_down():
	if state==STATES.WAIT:
		if current_floor>0:
			target_floor = current_floor-1
			_moving(Vector2(global_position.x, floors[target_floor]))
	return moving
	
func _moving(targetpos):
	state = STATES.MOVE
	moving = true
	var player_position = game.player.global_position
	var target_player_position = targetpos+(player_position-global_position)
	$tween.interpolate_property(self, "position", global_position, targetpos, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.interpolate_property(game.player, "position", player_position, target_player_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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