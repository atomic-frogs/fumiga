extends KinematicBody2D



const SNAP_DIRECTION := Vector2.DOWN
const SNAP_VECTOR_LENGTH := 32.0

const STOP_ON_SLOPE := true
const MAX_SLIDES := 4
const MAX_SLOPE_ANGLE := deg2rad(46)

export var speed := 600.0
export var jump_strength := 1400.0
export var gravity := 4500.0
export var up_dir := Vector2.UP

var _velocity := Vector2.ZERO
var _snap_vector := SNAP_DIRECTION * SNAP_VECTOR_LENGTH
var walking_dir := Vector2.UP

#onready var _pivot: Node2D = $PlayerSideSkin
#onready var _anim_player: AnimationPlayer = $PlayerSideSkin/AnimationPlayer
#onready var _start_scale := _pivot.scale


func _physics_process(delta: float) -> void:
	var horizontal_direction := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)

	var is_jumping := Input.is_action_just_pressed("jump") and ( is_on_floor() or walking_dir.x or walking_dir.y)
	var is_jump_cancelled := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_landing := _snap_vector == Vector2.ZERO and is_on_floor()
	
	if is_on_wall() && walking_dir.x == 0:
		walking_dir = Vector2(-horizontal_direction, 0)
#	if is_on_floor():
#			up_dir = Vector2.UP
		
	if walking_dir.y != 0:
		_velocity.x = horizontal_direction * speed
		_velocity.y += (gravity * -walking_dir.y)* delta
	else:
		_velocity.x = 0
		_velocity.y = horizontal_direction * speed
		
	print(up_dir)
#	if is_on_wall():
#		up_dir = Vector2(-horizontal_direction, 0)
	if is_jumping && walking_dir.x:
		print(is_jumping)
		_velocity.x = jump_strength  * -up_dir.x
		_snap_vector = Vector2.ZERO
		walking_dir = Vector2.UP
	elif is_jumping:
		_velocity.y = -jump_strength  * -up_dir.y
		_snap_vector = Vector2.ZERO
	elif is_jump_cancelled:
		_velocity.y = 0.0
	elif is_landing:
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH

#	if Input.is_action_just_pressed("e"):
#		up_dir = -up_dir

	_velocity = move_and_slide_with_snap(
		_velocity, _snap_vector, up_dir, STOP_ON_SLOPE, MAX_SLIDES, MAX_SLOPE_ANGLE
	)
	#_velocity = move_and_slide(_velocity, up_dir)

	# Visuals
#	if not is_zero_approx(horizontal_direction):
#		_pivot.scale.x = sign(horizontal_direction) * _start_scale.x
#
#	if is_jumping:
#		_anim_player.play("jump")
#	elif is_on_floor():
#		if not is_zero_approx(horizontal_direction) and not is_on_wall():
#			_anim_player.play("run")
#		else:
#			_anim_player.play("idle")
#	elif _velocity.y > 0.0:
#		_anim_player.play("fall")


#func get_look_direction() -> float:
#	return sign(_pivot.scale.x)
