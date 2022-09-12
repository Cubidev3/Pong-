extends Node
class_name PlayerStatsMensager

var player_stat: PlayerStats

func _make(stats: PlayerStats) -> PlayerStatsMensager:
	player_stat = stats
	return self
