extends KinematicBody2D

var SNAP_DIRECTION := Vector2.DOWN
const SNAP_VECTOR_LENGTH := 32.0

const STOP_ON_SLOPE := true
const MAX_SLIDES := 4
const MAX_SLOPE_ANGLE := deg2rad(46)

export var speed := 600.0
export var jump_strength := 1400.0
export var gravity := 3500.0
export var up_dir := Vector2(1,1)

var _velocity := Vector2.ZERO
var _snap_vector := SNAP_DIRECTION * SNAP_VECTOR_LENGTH
var walking_dir := Vector2.UP

onready var _coyote_timer: Timer = $CoyoteTimer
#onready var _pivot: Node2D = $PlayerSideSkin
#onready var _anim_player: AnimationPlayer = $PlayerSideSkin/AnimationPlayer
#onready var _start_scale := _pivot.scale


func _physics_process(delta: float) -> void:
	var horizontal_direction := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var vertical_direction := (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	var SNAP_DIRECTION := -up_dir
	var is_falling := _velocity.y > 0.0 
	var is_jumping := Input.is_action_just_pressed("jump") and (is_on_floor() or not _coyote_timer.is_stopped()) 
	var is_jump_cancelled := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_landing := _snap_vector == Vector2.ZERO and is_on_floor()
	var not_sticky := false
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		if collision.collider.is_in_group("not_sticky"):
			not_sticky = true

#	if Input.is_action_just_pressed("esc"):
#		get_tree().paused = true
	
	if is_on_wall() && abs(horizontal_direction) &&  !not_sticky:
		if up_dir.x == 0:
			up_dir = Vector2(-horizontal_direction, 0)
		else:
			up_dir = Vector2(0, -horizontal_direction)
	elif is_on_ceiling() && Input.is_action_pressed("jump"):
		up_dir = Vector2.DOWN


	if up_dir.y != 0:
		_velocity.x = horizontal_direction * speed
		_velocity.y += (gravity * -up_dir.y) * delta
	else:
		_velocity.x += (gravity * -up_dir.x) * delta
		_velocity.y = clamp((horizontal_direction * up_dir.x) * speed + vertical_direction * speed, -speed, speed)
		


#	print(up_dir)
#	if is_on_floor():
#		print("Is on floor:")
#	if is_on_wall():
#		print("Is on wall:")
#	if is_on_ceiling():
#		print("Is on ceiling")

	if Input.is_action_just_pressed("jump") && abs(up_dir.x) :
		_velocity.x = jump_strength  * up_dir.x
		_velocity.y = -jump_strength  
		_snap_vector = Vector2.ZERO
		up_dir = Vector2.UP
		_coyote_timer.stop()
	elif is_jumping:
		_velocity.y = -jump_strength  * -up_dir.y
		_snap_vector = Vector2.ZERO
		_coyote_timer.stop()
	elif is_jump_cancelled:
		_velocity.y = 0.0
	elif is_landing:
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH
		_coyote_timer.stop()

	if (!is_on_ceiling() && !is_on_floor() && !is_on_wall()) && !is_jumping:
		up_dir = Vector2.UP
	if is_falling && (is_on_floor() or is_on_ceiling() or is_on_wall()):
		_coyote_timer.start()
	if Input.is_action_just_pressed("e"):
		up_dir = Vector2.UP
 
	# Refatorar pelo amor de deus
	if Input.is_action_just_pressed("e") or (Input.is_action_just_pressed("move_down")  and up_dir.y == 1 and !is_on_wall()):
		up_dir = Vector2.UP
	elif Input.is_action_just_pressed("e") or (Input.is_action_just_pressed("move_right")  and up_dir.x == 1 and !is_on_wall()):
		up_dir = Vector2.UP
	elif Input.is_action_just_pressed("e") or (Input.is_action_just_pressed("move_left")  and up_dir.x == -1 and !is_on_wall()):
		up_dir = Vector2.UP
	
	_velocity = move_and_slide_with_snap(
		_velocity, _snap_vector, up_dir, STOP_ON_SLOPE, MAX_SLIDES, MAX_SLOPE_ANGLE
	)

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
