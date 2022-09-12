extends Node2D

var stat: PlayerStats
var size1 = preload("res://Actors/Size1.tscn")
export var team = 2
export var input_team = 2
export var is_enemy_spawnner = false

func _ready() -> void:
	if is_enemy_spawnner:
		stat = get_parent().get_parent().get_node("enemy_stats").get("player_stat")
	else: 
		stat = get_parent().get_parent().get_node("player_stats").get("player_stat")
	print(is_enemy_spawnner, " : ", stat.size)
	get_parent().call_deferred("add_child", size1.instance()._make(stat, global_position))
