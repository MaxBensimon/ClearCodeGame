extends StaticBody2D
class_name ItemContainer

# Setting the rotation so that items will pop out in the items facing direction (setting rotation before
# ready doesn't work, as the nodes have not been added yet):
@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)

var opened: bool = false

# Ignoring the unused signal warning as the analyzer is 
# script scoped and does not understand that the signal
# is used in the child classes.
@warning_ignore("unused_signal")
signal open(pos, direction)
