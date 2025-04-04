extends Node

var num: int

func _on_pitch_timer_timeout() -> void:
	num = randi_range(0, 10)
	if num <= 4:
		move_pitch(1)
	if num > 4 and num <= 7:
		move_pitch(.9)
	if num > 7:
		move_pitch(1.1)

func move_pitch(end: float):
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "pitch_scale", end, .2)
