extends CharacterBody2D

var player_nearby: bool = false
var can_shoot_laser: bool = true
var right_gun_use: bool = true

var invulnerable: bool = false

var health: int = 30

signal laser(pos, direction)

func hit():
	if not invulnerable:
		invulnerable = true
		$Timers/IFrames.start()
		health -= 10
		$Sprite2D.material.set_shader_parameter("progress", 1)
	if health <= 0:
		queue_free()

func _process(_delta: float) -> void:
	if player_nearby:
		look_at(Globals.player_pos)
		if can_shoot_laser:
			var marker_node = $LaserSpawnPositions.get_child(right_gun_use) # GDScript converts datatypes to suit its needs.
			right_gun_use = not right_gun_use
			var pos: Vector2 = marker_node.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_shoot_laser = false
			$Timers/LaserCooldown.start()

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true

func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false

func _on_laser_cooldown_timeout() -> void:
	can_shoot_laser = true

func _on_i_frames_timeout() -> void:
	invulnerable = false
	$Sprite2D.material.set_shader_parameter("progress", 0)
