extends KinematicBody2D

export (int) var speed = 200

var target:= Vector2.ZERO
var velocity:= Vector2.ZERO
var is_disabled:= false


func _input(event):
	if is_disabled :
		return
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()


func disable():
	is_disabled = true


func _physics_process(delta):
	if is_disabled:
		return
	if target == Vector2.ZERO:
		return
	target.x = clamp(target.x, Global.TILE_SIZE, Global.screen_width - Global.TILE_SIZE)
	target.y = clamp(target.y, Global.TILE_SIZE, Global.screen_height - Global.TILE_SIZE)	
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)


