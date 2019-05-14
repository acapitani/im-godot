extends Node2D

const FIRST_SCENE = "res://scenes/elevator/elevator.tscn"
const MENU_SCENE = "res://scences/start_menu/start_menu.tscn"

func _ready():
	game.main = self
	#game.music = $music
	call_deferred("_first_screen")

func _first_screen():
	_load_scene(FIRST_SCENE)

var load_state = 0
var current_scene = ""
func _load_scene(scene):
	print( "Loading scene: ", scene, "   State: ", load_state )
	#print( game.gamestate )
	if load_state==0:
		#get_tree().paused = true
		# set current scene
		current_scene = scene
		# fade out
		$fade_layer/fadeanim.play("fade_out")
		load_state = 1
		$loadtimer.set_wait_time(0.3)
		$loadtimer.start()
	elif load_state==1:
		# hide hud
		#$hud_layer/hud.hide()
		# clear current act
		var children = $scenes.get_children()
		if not children.empty():
			_disconnect_scene(children[0])
			children[0].queue_free()
		load_state = 2
		$loadtimer.set_wait_time(0.1)
		$loadtimer.start()
	elif load_state == 2:
		# load new act
		var act = load(current_scene).instance()
		$scenes.add_child(act)
		_connect_scene(act)
		#if act is preload( "res://levels/level.gd" ):
		#	$hud_layer/hud.show()
		
		load_state = 3
		$loadtimer.set_wait_time( 0.1 )
		$loadtimer.start()
	elif load_state == 3:
		#show hud
		if current_scene != MENU_SCENE:
		#	$hud_layer/hud.show()
			pass
		else:
			#$hud_layer/hud.hide()
			pass
		# fade in
		$fade_layer/fadeanim.play("fade_in")
		# play stuff
		load_state = 4
		$loadtimer.set_wait_time( 0.3 )
		$loadtimer.start()
		get_tree().paused = false
	elif load_state == 4:
		print( "finished loading" )
		load_state = 0

func update_hud():
	pass
	#$hud_layer/hud/coinmgr/coincount/coincount.text = "%d" % game.gamestate.coins
	#if game.gamestate.coins > oldcoins:
	#	oldcoins = game.gamestate.coins
	#	$hud_layer/hud/coinget.play( "cycle" )

func _on_loadtimer_timeout():
	_load_scene(current_scene)

func _connect_scene(v):
	v.connect("restart_scene", self, "_restart_scene" )
	v.connect("next_scene", self, "_next_scene" )
	v.connect("game_over", self, "_game_over" )
	
func _disconnect_scene(v):
	v.disconnect("restart_scene", self, "_restart_scene" )
	v.disconnect("next_scene", self, "_next_scene" )
	v.disconnect("game_over", self, "_game_over" )
	
func _restart_scene():
	_load_scene(current_scene)

func _next_scene(next_scene):
	game.gamestate.start_position = null
	_load_scene(next_scene)

func _game_over():
	#print( cur_scn, " ", MENU_SCN )
	if current_scene==MENU_SCENE:
		get_tree().quit()
	else:
		_load_scene(MENU_SCENE)

var mstate = 0
var curmusic = null
func play_music(res):
	#print( " play music ", mstate )
	#print( curmusic, " ", res )
	match mstate:
		0:
			curmusic = res
			mstate = 1
			#$music/musicfade.play("fadeout")
		1:
			#print( "STARTING MUSIC" )
			
			#$music.stream = curmusic
			#$music.play()
			#$music/musicfade.play("fadein")
			mstate = 2
		2:
			mstate = 0


func _on_musicfade_animation_finished(anim_name):
	play_music( null )
