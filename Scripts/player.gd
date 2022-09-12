extends KinematicBody2D

class_name Player

var velocity = Vector2(0,0)
var direction = 0
var init_pos = Vector2(0,0)
export var speed = 4
export var life = 4
export var force = 4
export var special = 4
var size = 4
var real_life = 0

export var speed_base = 192
export var base_life = 4
export var super_speed_ball_multiplier = 64
export var base_special = 8

var attack = false
onready var attack_cooldown = $"Attack Cooldown"
onready var sprite = $Sprite

export var time_to_top = 9
export var time_to_zero = 5
var acceleration = 0
var deacceleration = 0
export var charge_multiplier: float = 1

onready var animation = $AnimationPlayer

var just_ended = true
var attack_tap = false
var released_attack = false
var charging = false
var charge = 0
export var charge_rate = 1
var cooling = false
var cooldown = 0
var max_cooldown = 10
export var minimal_cooldown = 7
export var perfect_attack = false
export var initial_perfect_attack_frame = 0
export var perfect_attack_frames = 7
export var attacking = false
var max_tap_attack_frame = 5
var tap_attack_frame = 5

export var hit_cooldown = 20

export var attack_fliquering_rate = 6
var attack_flick = 0

var spr_size_1 = preload("res://Sprites/Size1.png")
var spr_size_2 = preload("res://Sprites/Size2.png")
var spr_size_3 = preload("res://Sprites/Size3.png")
var spr_size_4 = preload("res://Sprites/Size4.png")
var normal_height = 32

#debug
var debug_timer_paused = true
var debug_time = 0

var team = 2
var input_team = 2
var move_up: String = "up"
var move_down: String = "down"
var move_attack: String = "attack"

func _set_size(_size: int) -> void:
	match _size:
		1:
			sprite.texture = spr_size_1
		2:
			sprite.texture = spr_size_2
		3:
			sprite.texture = spr_size_3
		4:
			sprite.texture = spr_size_4
	$CollisionShape2D.shape.extents = Vector2(8,normal_height*_size)
	$AttackHitbox/CollisionShape2D.shape.extents = Vector2(8,normal_height*_size)
	print(_size)

func _make(stats: PlayerStats, init_position: Vector2) -> Player:
	init_pos = init_position
	speed = stats.speed
	life = stats.life
	special = stats.special
	force = stats.strength
	size = stats.size
	team = stats.team
	input_team = stats.input_team
	return self

func _ready() -> void:
	acceleration = speed_base * speed/time_to_top
	deacceleration = speed_base * speed/time_to_zero
	global_position = init_pos
	real_life = life * base_life
	tap_attack_frame = max_tap_attack_frame
	if init_pos.x > 0: rotation_degrees = 180
	_set_size(size)
	animation.play("normal")
	if input_team == 2:
		move_up += "2"
		move_down += "2"
		move_attack += "2"

func _input(event):
	direction = Input.get_action_strength(move_down) - Input.get_action_strength(move_up)
	attack = Input.is_action_pressed(move_attack)
	released_attack = Input.is_action_just_released(move_attack)
	if Input.is_action_just_pressed(move_attack) and not attacking and animation.current_animation != "Damaged":
		animation.play("attack")
		attacking = true

func _physics_process(delta: float) -> void:
	if debug_timer_paused == false: debug_time += 1
	
	if tap_attack_frame < max_tap_attack_frame: tap_attack_frame += 1
	
	if direction != 0:
		var adding_speed = acceleration * direction * charge_multiplier
		
		if velocity.y > 0 and direction < 0 or velocity.y < 0 and direction > 0:
			if abs(velocity.y + adding_speed) < speed_base * speed * abs(direction) * charge_multiplier:
				velocity.y += adding_speed
			else:
				velocity.y = speed_base * speed * direction * charge_multiplier
			
		if abs(velocity.y + adding_speed) < speed_base * speed * abs(direction) * charge_multiplier:
			velocity.y += adding_speed
		else:
			velocity.y = speed_base * speed * direction * charge_multiplier
			
	else:
		if abs(velocity.y) > deacceleration:
			velocity.y -= sign(velocity.y) * deacceleration
		else:
			velocity.y = 0		
	
	if charging:
		if charge + delta < force:
			charge += 1.5 * delta
		else:
			charge = force
			
		if !attack:
			charging = false
			animation.play("Charged_attack")
			
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider is Ball:
			_take_damage(col.collider.damage)
	
func _take_damage(damage: int):
	real_life -= damage
	animation.stop(true)
	animation.play("Damaged")
	charge = 0
	charging = false

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack":
			if Input.is_action_pressed(move_attack):
				animation.play("return_charging")
			else:
				animation.play("return_normal")
		"return_charging":
			charging = true
			animation.play("Charging")
		"return_normal":
			animation.play("normal")
			attacking = false
		"Charged_attack":
			animation.play("return_normal")
			charge = 0
		"Damaged":
			animation.play("normal")
			attacking = false


func _on_AttackHitbox_body_entered(body):
	if body is Ball:
		var distance = (global_position - body.global_position).normalized()
		body.speed += floor(charge) + 1
		if body.hit_team == team and not charging and body.super_speed: body.velocity = (body.velocity.length() + (floor(charge) * super_speed_ball_multiplier)) * 1.2 * distance * Vector2(-1,1)
		else: body.velocity = (body.speed + (floor(charge) * super_speed_ball_multiplier)) * distance * Vector2(-1,1)
		if floor(charge) > 0: body.super_speed = true
		body.hit_team = team
		body.damage = 1 + floor(charge)
		print(body.velocity.length())
		#var distance = who.global_position - (global_position + Vector2(((who.size - 1) * 4 + 8) * col.normal.x, 0))
		#			speed += floor(who.charge) + 1
		#			velocity = (speed + (floor(who.charge) * who.super_speed_ball_multiplier)) * distance.normalized() * Vector2(-1,1)
		#			if floor(who.charge) > 0:
		#				super_speed = true
		#			print(velocity.length())
		#		else:
