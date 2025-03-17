extends Area2D

@export var speed: int = 1000 # Setting @export exposes the variable in the node's inspector tab.
var direction: Vector2 = Vector2.UP

func _process(delta: float) -> void:
	position += direction * speed * delta
