extends Reference

class_name PlayerStats

var speed = 1
var life = 1
var special = 1
var strength = 1
var size = 1
var team = 2
var input_team = 2

func _init(_speed: int, _life: int, _special: int, _strength: int, _size: int, _team: int, _input_team: int) -> void:
	speed = _speed
	life = _life
	special = _special
	strength = _strength
	size = _size
	team = _team
	input_team = _input_team
	
func Randomized_Stat(max_points: int) -> void:
	var p = max_points
	var rng = RandomNumberGenerator.new()
	while p > 0:
		rng.randomize()
		var what_stat = rng.randi_range(1,5)
		match what_stat:
			1:
				if speed < 4:
					speed += 1
					p -= 1
			2:
				if life < 4:
					life += 1
					p -= 1
			3:  
				if special < 4:
					special += 1
					p -= 1
			4:
				if strength < 4:
					strength += 1
					p -= 1
			5:
				if size < 4:
					size += 1
					p -= 1
