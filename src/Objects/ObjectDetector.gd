extends Area2D

signal detected_coin
signal detected_no_coin(position)

var has_detected := false


func get_has_detected() -> bool:
	return has_detected


func detected_object():
	if not has_detected:
		has_detected = true


func _on_ObjectDetector_body_entered(body):
	detected_object()


func _on_ObjectDetector_area_entered(area):
	detected_object()
