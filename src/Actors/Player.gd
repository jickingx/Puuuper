extends KinematicBody2D

const SPEED_MAX = 600
const ACCELERATION = 64
export (int) var speed = 200

var target:= Vector2.ZERO
var velocity:= Vector2.ZERO
var is_disabled:= false


func _input(event):
	if is_disabled :
		return
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()


func _physics_process(delta):
	if is_disabled:
		return
	if target == Vector2.ZERO:
		return
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)


func disable():
	is_disabled = true


func speedup(val = 2):
	speed += val * 2
	speed = clamp(speed, 0 , SPEED_MAX)
