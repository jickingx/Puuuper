extends Area2D

signal picked


func _on_Coin_body_entered(body):
	if body.is_in_group("players") :
		die()


func die():
	emit_signal("picked")
	$CollisionShape2D.queue_free()
	$AnimationPlayer.play("picked")
	yield ($AnimationPlayer, "animation_finished")
	$AudioStreamPlayer2D.play()
	yield ($AudioStreamPlayer2D, "finished")
	queue_free()
