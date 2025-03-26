extends Area2D

var rotation_speed: int = 5
# I don't know what would be a simpler approach of adding different probabilities than this...
# It seems like bad and KISS code at the same time:
var available_options = ['laser', 'grenade', 'health']
var type = available_options[randi()%len(available_options)]

var direction: Vector2
var distance: int = randi_range(150, 250)

func _ready() -> void:
	if type == 'laser':
		$Sprite2D.modulate = Color("00e4e5")
	elif  type == 'grenade':
		$Sprite2D.modulate = Color("ff4d3c")
	elif  type == 'health':
		$Sprite2D.modulate = Color("33eb00")
	
	# Creating a tween for the spawn animation (move the item from spawn position to target position over time):
	var target_pos = position + direction * distance
	var tween = create_tween()
	 # To run tween properties simultaneously:
	tween.set_parallel(true)
	# 'self' means 'this' or the node with the script attached:
	tween.tween_property(self, "position", target_pos, .1)
	# '.from' sets a starting value:
	tween.tween_property(self, "scale", Vector2(1,1), .2).from(Vector2(0,0))

func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func _on_body_entered(_body: Node2D) -> void:
	#body.add_item(type)
	# Setting the global health amount (getset) is better than going through the player script.
	# The global values are set based on these conditionals of this signal:
	if type == 'health':
		Globals.health += 10
	elif type == 'laser':
		Globals.laser_amount += 5
	elif type == 'grenade':
		Globals.grenade_amount += 1
	
	queue_free()
