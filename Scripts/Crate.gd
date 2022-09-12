extends PhysicalBody

class_name Crate
var start_point = Vector2(0,0)
var col_list: Array = []

func _build(start_position: Vector2) -> Crate:
	start_point = start_position
	return self
	
func _ready():
	global_position = start_point

func _physics_process(delta: float) -> void:
	var col = move_and_collide(dir.normalized() * speed * delta)
	
	if col:
		var who = col.collider
		if who is PhysicalBody:
			var col_speed = _speed_from_collision(mass, who.mass, speed, who.speed)
			if dir == Vector2.ZERO:
				dir = who.dir
			else:
				dir = dir.bounce(col.normal)
			speed = col_speed
		else:
			dir = dir.bounce(col.normal)
			
func _speed_from_collision(mass1: float, mass2: float, speed1: float, speed2: float) -> float:
	var result = 0
	result = ((speed1 * mass1 + speed2 * mass2) * (mass2/(mass1 + mass2)) / mass1)
	return result
