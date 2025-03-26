extends CharacterBody2D

var canShoot: bool = true
var canThrowGrenade: bool = true

@export var max_speed: int = 500
var speed: int = max_speed

signal shot_laser(pos, direction)
signal threw_grenade(pos, direction)

func hit():
	print("player was hit")

# Setting an underscore before delta means that it is available but the method should ignore it.
func _process(_delta: float) -> void:
	
	# get_vector is used with 2D spatial input mapping. It seems like it also clamps diagonal movement.
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Vector math to get the pointing direction of gun. .normalized does some vector math magic so that you don't operate with huge numbers that make stuff inconsistent.
	var gun_direction = (get_global_mouse_position() - position).normalized()
	
	# velocity is a property of a CharacterBody. Delta is really important to set but here it happpens automatically through the velocity property.
	velocity = direction * speed # * delta
	
	# How you move a CharacterBody is just always with this method
	move_and_slide()
	
	# Sending the player's position to the global script so that enemies can track them.
	Globals.player_pos = global_position
	
	# Rotation. This method is inbuilt and just makes the node that it is attached to point to something.
	# The global position of the mouse is target, which is weird with sprites that have 0 degrees rotation
	# as the standard rotation or something is 90. To fix just rotate the sprite.
	look_at(get_global_mouse_position())
	
	if (Input.is_action_pressed("primary action")) and canShoot and Globals.laser_amount > 0:
		# Accessing the global count of laser rounds:
		Globals.laser_amount -= 1
		canShoot = false
		# Setting the one shot enabled particle to true:
		$GPUParticles2D.emitting = true
		# Randomly select a Marker2D as start position:
		var laser_markers = $LaserStartPositions.get_children()
		# Select a random marker from the list. The Godot random is a bit weird but the method below is common:
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		
		# Send a random start position with the emit. The position needs to be global:
		shot_laser.emit(selected_laser.global_position, gun_direction)
		# .position is always relative to the parent, i.e. it is the local_position.
		# The .global_position is independent of any parent and is a coordinate in the game world.
		# Everything with a transform has both a local and global position. The difference is in
		# the position's relation to it's parent object, if it has any.
		
		# Starting the Timer node, which will run for the specified time and then run the signal timeout() below:
		$LaserShootTimer.start()
		
	if (Input.is_action_pressed("secondary action")) and canThrowGrenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		canThrowGrenade = false
		var grenade_pos = $LaserStartPositions/Marker2D
		threw_grenade.emit(grenade_pos.global_position, gun_direction)
		$GrenadeReloadTimer.start()
		
# Setting the signal in the Timer node and connecting it to the player script. If changes made in the Timer node it will affect when this method is run.
func _on_laser_shoot_timer_timeout() -> void:
	canShoot = true

func _on_grenade_reload_timer_timeout() -> void:
	canThrowGrenade = true
