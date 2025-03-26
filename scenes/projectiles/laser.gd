extends Area2D

@export var speed: int = 1500 # Setting @export exposes the variable in the node's inspector tab.
var direction: Vector2 = Vector2.UP

func _ready():
	$SelfDestructTimer.start()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# You can check whether something contains a script with a certain identifier, as to not
	# crash the game when you try to call something that doesn't exist in the script of the node.
	if "hit" in body:
		body.hit()
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
