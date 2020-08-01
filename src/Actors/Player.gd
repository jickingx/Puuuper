extends KinematicBody2D
signal died

const ParticlesExplosion = preload("res://src/FX/Particles/Explosion.tscn")
const SPEED_MAX = 666
const ACCELERATION = 64
export (int) var speed = 200

var target:= Vector2.ZERO
var velocity:= Vector2.ZERO
var is_disabled:= false
var state_machine


func _ready():
	$AnimationTree.active = true
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.travel("wobble")


func _input(event):
	if is_disabled :
		return
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()
		$Sprites/EyeLeft.rotation = target.angle_to_point(position)
		$Sprites/EyeRight.rotation = target.angle_to_point(position)


func _physics_process(delta):
	if is_disabled:
		return
	if target == Vector2.ZERO:
		return
	#velocity = position.direction_to(target) * speed
	velocity = position.direction_to(target) * speed * 60 * delta
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
		state_machine.travel("move")
	else:
		state_machine.travel("idle")
	


func disable():
	is_disabled = true


func speedup(val = 2):
	speed += val * 2
	speed = clamp(speed, 0 , SPEED_MAX)


func die():
	is_disabled = true
	$CollisionShape2D.queue_free()
	var ex = ParticlesExplosion.instance()
	ex.position = self.position
	Global.current_scene.add_child(ex)
	ex.emitting = true
	emit_signal("died")
	#$AnimationPlayer.play("die")
	#yield ($AnimationPlayer, "animation_finished")
	$AudioStreamPlayer2D.play()
	yield ($AudioStreamPlayer2D, "finished")
	#queue_free()

