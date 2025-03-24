extends LevelParent # Inheritance that adds the parent class here with this line.

func _on_gate_player_entered_gate(_body) -> void:
	# The get_tree(). is not necessary
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, .5)
	
	# Changing the scene to 'inside'
	get_tree().change_scene_to_file("res://scenes/levels/inside.tscn")
