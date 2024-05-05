extends "res://Scenes/scene.gd"
@onready var board = $Board
@onready var gear = $Reset/Gear

func _on_reset_interact() -> void:
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(gear,"rotation_degrees",360.0,0.2).as_relative()
	tw.tween_callback(board.reset)