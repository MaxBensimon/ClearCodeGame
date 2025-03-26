extends StaticBody2D
class_name ItemContainer

# Setting the rotation so that items will pop out in the items facing direction (setting rotation before
# ready doesn't work, as the nodes have not been added yet):
@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)

var opened: bool = false

signal open(pos, direction)
