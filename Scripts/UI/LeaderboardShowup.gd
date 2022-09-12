extends Control

onready var anim = $AnimationPlayer
var left_value: int = 0
var right_value: int = 0
onready var board = $Panel2/Label

signal animation_ended

func _show_leaderboard() -> void:
	anim.play("run")
	
func _add_points_to(is_for_left: bool, value: int):
	if is_for_left: left_value += value
	else: right_value += value
	board.text = str(left_value) + " | " + str(right_value)
	_show_leaderboard()
	
func _on_BallScorerLeft_body_entered(body):
	if body is Ball:
		_add_points_to(false, 1)

func _on_BallScorerRigth_body_entered(body):
	if body is Ball:
		_add_points_to(true, 1)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_ended")
