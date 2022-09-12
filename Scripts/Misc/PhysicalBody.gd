extends KinematicBody2D

class_name PhysicalBody

var velocity = Vector2(0,0)
var speed: float = 100
var dir = Vector2(0,0)
export var deacceleration = 2
export var mass = 2
var rotation_vel = 0

func _add_force(force: Vector2):
	speed += force.length()
	
func _set_force(force: Vector2):
	speed = force.length()
	
func _set_force_with_mass(force: Vector2):
	speed = force.length()/mass
	
func _physics_process(delta: float) -> void:
	if speed > deacceleration:
		speed -= sign(speed) * deacceleration
	else:
		speed = 0
