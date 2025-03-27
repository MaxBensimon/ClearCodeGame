extends CharacterBody2D

var active: bool = false
var movement_speed: int = 300
var vurnerable: bool = true
var player_nearby: bool = false

var health = 30

func hit():
	if vurnerable:
		vurnerable = false
		$Timers/HitTimer.start()
		health -= 10
		$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
		$Particles/HitParticles.emitting = true
	if health <= 0:
		await get_tree().create_timer(.5).timeout # Let the particles finish before removing the scene
		queue_free()
	

func _process(_delta: float) -> void:
	var direction = (Globals.player_pos - position).normalized() # A Vector2
	velocity = direction * movement_speed
	if active:
		move_and_slide()
		look_at(Globals.player_pos)

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true
	$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
	
func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	active = false
	$AnimatedSprite2D.stop()

func _on_animated_sprite_2d_animation_finished() -> void:
	if player_nearby:
		Globals.health -= 10
		$Timers/AttackTimer.start()

func _on_hit_timer_timeout() -> void:
	vurnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)

func _on_attack_timer_timeout() -> void:
	$AnimatedSprite2D.play("attack")
