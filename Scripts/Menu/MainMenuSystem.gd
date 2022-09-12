extends Control

const player_customization_screen = preload("res://Actors/Menu/PointsMenu.tscn")

func _start_button() -> void:
	get_parent().add_child(player_customization_screen.instance())
	queue_free()


func _on_New_Game_button_down():
	_start_button()
