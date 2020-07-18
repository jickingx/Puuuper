extends Area2D

signal picked


func _on_Coin_body_entered(body):
	if body.is_in_group("players") && body.has_method("die") :
		body.die()


