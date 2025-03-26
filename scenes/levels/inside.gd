extends LevelParent

# Preloading the scene makes transitions a lot smoother.
# It also gives a bunch of control over when a scene is loaded and if a scene is loaded,
# e.g. as a random dungeon room generation or something...
#var outside_level_scene: PackedScene = preload("res://scenes/levels/outside.tscn")

func _on_exit_gate_area_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, .5)
	
	# Changing the scene to 'outside'
	#get_tree().change_scene_to_file("res://scenes/levels/outside.tscn")
	
	# This seems like a better approach
	#get_tree().change_scene_to_packed.call_deferred(outside_level_scene)
	
	TransitionLayer.change_scene.call_deferred("res://scenes/levels/outside.tscn")
