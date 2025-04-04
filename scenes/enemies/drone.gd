extends CharacterBody2D

var active: bool = false
var vulnerable: bool = true
var max_speed: int = 600
var speed: int = 0
var health: int = 50
var explosion_active: bool = false
var explosion_radius: int = 400

func _ready() -> void:
	$Explosion.hide()
	$Sprite2D.show()

func _process(delta: float) -> void:
	if active:
		var direction = (Globals.player_pos - position).normalized() # A vector2
		velocity = direction * speed
		if health > 0:
			look_at(Globals.player_pos)
			# move_and_collide doesn't automatically incorporate multiplicition with delta:
			var collision = move_and_collide(velocity * delta)
			if collision:
				health = 0
				$AnimationPlayer.play("Explosion")
				explosion_active = true
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius
			if "hit" in target and in_range:
				target.hit()

func speed_up():
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 6)

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$HitTimer.start()
		$Sprite2D.material.set_shader_parameter("progress", 1)
		$Node/HitSound.play()
	if health <= 0:
		$AnimationPlayer.play("Explosion")
		explosion_active = true
		
func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	speed_up()

func _on_hit_timer_timeout() -> void:
	vulnerable = true
	$Sprite2D.material.set_shader_parameter("progress", 0)
