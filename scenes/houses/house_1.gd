extends Area2D

# Signal to send to other nodes
signal player_entered
signal player_exited

# The signal of the node that triggers (an event)
func _on_body_entered(_body: Node2D) -> void:
	player_entered.emit()

func _on_body_exited(_body: Node2D) -> void:
	player_exited.emit()
