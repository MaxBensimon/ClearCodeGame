extends ItemContainer

func hit():
	if opened == true:
		return
	
	$LidSprite.hide()
	var pos = $SpawnPositions/Marker2D.global_position
	open.emit(pos, current_direction)
	
	opened = true
