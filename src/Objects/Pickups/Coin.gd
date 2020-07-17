extends Area2D

signal picked


func _ready():
	$AnimationPlayer.play("default")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "picked":
		queue_free()


func _on_Coin_body_entered(body):
	if body.is_in_group("players") :
		$CollisionShape2D.queue_free()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("picked")
		emit_signal("picked")
