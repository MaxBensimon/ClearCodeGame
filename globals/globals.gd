# A global script that is autoloaded on start and therefore is not part of any node.
# The data here can be accessed in any script just by calling Globals.my_var. The
# reason why 'Globals' is capitalized is due to how I named it in the autoload
# settings (Project -> Project Settings -> Globals -> Autoload).
# This is a good way to do persistence, which is done via signals and
# gettter-setters. Like the stat_change system below.

extends Node

signal stat_change

var player_hit_sound: AudioStreamPlayer2D

var laser_amount: int = 20:
	set(value):
		laser_amount = value
		stat_change.emit()

var grenade_amount: int = 5:
	set(value):
		grenade_amount = value
		stat_change.emit()

var player_vulnerable: bool = true
var health = 60:
	set(value):
	# If the value is greater than health it means that a health item was picked up, which should be possible even when invulnerable.
		if value > health:
			health = min(value, 100) # 'health' cannot be greater than 100.
		else:
			if player_vulnerable:
				player_hit_sound.play()
				health = value
				player_vulnerable = false
				player_invulnerable_timer()
		stat_change.emit()

# Making a timer without using a timer node
func player_invulnerable_timer():
	await get_tree().create_timer(.5).timeout
	player_vulnerable = true

var player_pos: Vector2

func _ready() -> void:
	# The 'new' keyword creates a new node through the script:
	player_hit_sound = AudioStreamPlayer2D.new()
	# Now the AudioStreamPlayer2D's properties are accessible here even though it doesn't exist yet:
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")
	# Add the AudioStreamPlayer2D to the scene tree:
	add_child(player_hit_sound)
