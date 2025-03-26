extends CanvasLayer

func _ready() -> void:
	$ColorRect.modulate = Color(0, 0, 0, 0)

func change_scene(target: String) -> void:
	$AnimationPlayer.play("fade_to_black")
	
	await $AnimationPlayer.animation_finished
	
	# Godot does not allow removing a body that is currently undergoing physics processes.
	# The call needs to be deferred, which means to move it to the end of the current frame.
	get_tree().change_scene_to_file.call_deferred(target)
	
	$AnimationPlayer.play_backwards("fade_to_black")
