extends Node2D

# Creating a class with a given name that lets you inherit from it.
class_name LevelParent

# Preloading the laser scene so that it can be used in the level scene without it being a node in the hierarchy at ready.
var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene: PackedScene = preload("res://scenes/items/item.tscn")

func _ready() -> void:
	for container in get_tree().get_nodes_in_group('Container'):
		container.connect('open', _on_container_opened) # Signal and function
	for scout in get_tree().get_nodes_in_group('Scouts'):
		scout.connect('laser', _on_scout_laser)

func _on_container_opened(pos, direction):
	# Create an item scene and place it at some spawn position (gotten from the function in the item's script).
	var item = item_scene.instantiate()
	item.position = pos
	
	item.direction = direction
	$Items.add_child.call_deferred(item)

func _on_player_shot_laser(pos, direction) -> void:
	create_laser_projectile(pos, direction)
	
func _on_scout_laser(pos, direction):
	create_laser_projectile(pos, direction)

func create_laser_projectile(pos, direction):
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

# Signal from player that is emitted when colliding with a item. Goes through here to get to the UI elements
# to update them:
#func _on_player_update_stats() -> void:
	#$UI.update_laser_text()
	#$UI.update_grenade_text()
