extends TileMapLayer

func ate_grass(graze_pos:Vector2):
	var celled=local_to_map(graze_pos)
	set_cell(celled,3)
		
