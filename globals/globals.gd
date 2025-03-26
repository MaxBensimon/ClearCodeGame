# A global script that is autoloaded on start and therefore is not part of any node.
# The data here can be accessed in any script just by calling Globals.my_var. The
# reason why 'Globals' is capitalized is due to how I named it in the autoload
# settings (Project -> Project Settings -> Globals -> Autoload).
# This is a good way to do persistence, which is done via signals and
# gettter-setters. Like the stat_change system below.

extends Node

signal stat_change

var laser_amount: int = 20:
	set(value):
		laser_amount = value
		stat_change.emit()

var grenade_amount: int = 5:
	set(value):
		grenade_amount = value
		stat_change.emit()

var health = 60:
	set(value):
		health = value
		stat_change.emit()

var player_pos: Vector2
