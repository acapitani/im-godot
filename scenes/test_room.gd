extends "res://scenes/scene.gd"

func _ready():
	game.gamestate.current_scene = "res://scenes/test_room.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_player_exit_left():
	emit_signal("next_scene", "res://scenes/elevator/elevator.tscn" )

func _on_player_exit_right():
	emit_signal("next_scene", "res://scenes/elevator/elevator.tscn" )
