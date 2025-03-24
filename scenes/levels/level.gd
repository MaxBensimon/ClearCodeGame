extends Node2D

# Creating a class with a given name that lets you inherit from it.
class_name LevelParent

# Preloading the laser scene so that it can be used in the level scene without it being a node in the hierarchy at ready.
var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")

func _on_player_shot_laser(pos, direction) -> void:
	# Instantiating a laser scene from the preload above.
	var laser = laser_scene.instantiate() as Area2D
	# Setting the laser position from the variable recieved by the function through the signal.
	laser.position = pos
	# Setting the rotation of the laser sprite with radians to degrees (+ 90 to make it look right... like with player rotation).
	laser.rotation_degrees = rad_to_deg(direction.angle()) + 90
	# Setting the direction variable in the laser script to what it received in this script.
	laser.direction = direction 
	# Adding the laser scene as a child node of the Projectiles node in the Level scene for tidiness.
	$Projectiles.add_child(laser)

func _on_player_threw_grenade(pos, direction) -> void:
	var grenade = grenade_scene.instantiate() as RigidBody2D # You can tell Godot what something is which makes autocomplete work
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.speed
	$Projectiles.add_child(grenade)

# When the player enteres a house, zoom in
func _on_house_player_entered() -> void:
	# Creating a Tween, which is a simple animation type object that moves between two values over time.
	# It is for when an animation player node would be overkill and for simpler animations.
	# get_tree() returns the all the nodes in the given scene tree. Here a Tween is created and saved as
	# a variable.
	var tween = get_tree().create_tween()
	# Pressing ctrl+space when in an invoker gives the values needed for that function. The parameters below
	# are almost self explanatory: get a specific node, get a specific property of that node (in string form),
	# set the targetted or final value and set the duration of the animation.
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1, 1), 1)

# When the player exits a house, zoom out
func _on_house_player_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.6, 0.6), 1)
