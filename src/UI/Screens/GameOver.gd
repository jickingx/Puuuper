extends CanvasLayer

func show_hi_score():
	$MainMessage.text = "NEW HIGH SCORE"


func _on_ButtonPlayAgain_button_up():
	Global.restart_scene()

