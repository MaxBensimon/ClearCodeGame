extends StaticBody2D

# A custom signal that can be called between scenes. Normally signals are scene specific but by handling it like a
# variable it can be used in other scenes as well. It seems like signals are like events.
# The custom signal is grabbed like any other signal: Through the node list and then the specific script that declares it.
# Note that signals can take parameters.
signal player_entered_gate(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# When a signal is sent out or is triggered it is 'emitted'. The actual logic can be handled in the scripts that
	# subscribe to the signal or here. But depending on how complicated the logic is, I think it's fine to evaluate it
	# and not follow any hardline principles.
	player_entered_gate.emit(body)
