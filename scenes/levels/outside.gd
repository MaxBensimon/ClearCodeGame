extends LevelParent # Inheritance that adds the parent class here with this line.

func _on_gate_player_entered_gate(_body) -> void:
	# The get_tree(). is not necessary
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, .5)
	
	# Changing the scene to 'inside'. Calling the transition layer script to do it because it handles
	# the fade animation.
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")

# When the player enteres an outside house, zoom in
func _on_house_player_entered() -> void:
	# Creating a Tween, which is a simple animation type object that moves between two values over time.
	# It is for when an animation player node would be overkill and for simpler animations.
	# get_tree() returns the all the nodes in the given scene tree. Here a Tween is created and saved as
	# a variable.
	var tween = get_tree().create_tween()
	# Pressing ctrl+space when in an invoker gives the values needed for that function. The parameters below
	# are almost self explanatory: get a specific node, get a specific property of that node (in string form),
	# set the targetted or final value and set the duration of the animation.
	tween.tween_property($Player/Camera2D, "zoom", Vector2(.8, .8), 1)

# When the player exits an outside house, zoom out
func _on_house_player_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(.4, .4), 1)
