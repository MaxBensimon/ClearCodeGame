extends CharacterBody2D

var active: bool = false
var player_nearby: bool = false
var speed: int = 200
var vulnerable: bool = true
var health: int = 100

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos

# Need to use _physics_process here as the Navigation nodes are dependent on it.
func _physics_process(_delta: float) -> void:
	if active:
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		var look_angle = direction.angle()
		rotation = look_angle + PI / 2

func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	$AnimationPlayer.play("walk")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	active = false
	$AnimationPlayer.stop()

func _on_navigation_timer_timeout() -> void:
	if active:
		$NavigationAgent2D.target_position = Globals.player_pos

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true
	$AnimationPlayer.play("attack")

func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
	$AnimationPlayer.stop()

func attack():
	if player_nearby:
		Globals.health -= 10

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Skeleton2D/Torso/Torso.material.set_shader_parameter("progress", 1)
		$Skeleton2D/Torso/Head/Sprite2D.material.set_shader_parameter("progress", 1)
		$AudioStreamPlayer2D.play()
		$Timers/HitTimer.start()
	if health <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	vulnerable = true
	$Skeleton2D/Torso/Torso.material.set_shader_parameter("progress", 0)
	$Skeleton2D/Torso/Head/Sprite2D.material.set_shader_parameter("progress", 0)
