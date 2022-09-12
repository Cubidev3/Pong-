extends KinematicBody2D

class_name Ball

var velocity = Vector2(0,0)
export var speed = 300

var wallTimer = 3
var floorOrCeilingTimer = 3

export var super_speed_deacceleration = 1.5
var super_speed = false

var hit_team = 0

var damage = 1

func _random_velocity() -> Vector2:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = Vector2(rng.randf_range(-0.8, 0.8), rng.randf_range(-0.8, 0.8))
	if abs(result.x) < 0.1: result.x += sign(result.x) * 0.1
	if abs(result.y) < 0.1: result.y += sign(result.y) * 0.1
	return result.normalized()
	
func _collided_with_wall():
	if wallTimer == 0:
		wallTimer = 3
		velocity.x *= -1

func _collided_with_floor_or_ceiling():
	if floorOrCeilingTimer == 0:
		floorOrCeilingTimer = 3
		velocity.y *= -1
		
func _ready() -> void:
	velocity = _random_velocity() * speed
	
func _physics_process(delta: float) -> void:
	if wallTimer > 0: wallTimer -= 1
	if floorOrCeilingTimer > 0: floorOrCeilingTimer -= 1
	
	if super_speed:
		if velocity.length() > speed + super_speed_deacceleration:
			velocity -= velocity.normalized() * super_speed_deacceleration
		else:
			super_speed = false
			velocity = velocity.normalized() * speed
	
	var col = move_and_collide(velocity * delta)
	
	if col:
		var who = col.collider
		if who is Crate:
			who.speed = speed
			who.dir = velocity.normalized()
			velocity = velocity.bounce(col.normal)
		else:
			velocity = velocity.bounce(col.normal)
			
func _on_PointsBoard_animation_ended():
	global_position = Vector2(0,0)
	velocity = _random_velocity() * speed
