extends PathFollow2D

var speed: float = .01
var player_nearby: bool = false

@onready var line1: Line2D = $Turret/RayCast2D/Line2D
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D

@onready var gun_flare1: Sprite2D = $Turret/GunFlare1
@onready var gun_flare2: Sprite2D = $Turret/GunFlare2

func fire():
	Globals.health -= 20
	gun_flare1.modulate.a = 1
	gun_flare2.modulate.a = 1
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(gun_flare1, "modulate:a", 0, randf_range(.1, .5))
	tween.tween_property(gun_flare2, "modulate:a", 0, randf_range(.1, .5))

func _ready():
	line2.add_point($Turret/RayCast2D2.target_position)

func _process(delta: float) -> void:
	progress_ratio += speed * delta
	if player_nearby:
		$Turret.look_at(Globals.player_pos)

func _on_notice_area_body_entered(_body: Node2D) -> void:
	player_nearby = true
	$AnimationPlayer.play("laser_load")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
	$AnimationPlayer.pause()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(line1, "width", 0, randf_range(.1, .5))
	tween.tween_property(line2, "width", 0, randf_range(.1, .5))
	await tween.finished
	$AnimationPlayer.stop()
