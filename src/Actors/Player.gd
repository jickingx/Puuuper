extends KinematicBody2D

const TILE_SIZE = 64
const TARGET_MAX_X = 1024 - 64
const TARGET_MAX_Y = 600 - 64

export (int) var speed = 200

var target:= Vector2.ZERO
var velocity:= Vector2.ZERO


func _input(event):
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()

func _physics_process(delta):
	if target == Vector2.ZERO:
		return
	
	target.x = clamp(target.x, TILE_SIZE , TARGET_MAX_X)
	target.y = clamp(target.y, TILE_SIZE , TARGET_MAX_Y)
	
	velocity = position.direction_to(target) * speed
	# look_at(target)
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
