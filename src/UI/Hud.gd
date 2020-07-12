extends CanvasLayer


func set_score(val:int = 1):
	$LabelScore.text = str(val)


func set_timer(val:int = 1):
	$LabelTimer.text = str(val)


func set_score_hi(val):
	$LabelHiScore.text = str(val)
