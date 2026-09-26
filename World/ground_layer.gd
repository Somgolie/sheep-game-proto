extends TileMapLayer
@export var field:Node2D
var cell_status:Vector2i
var cells_dic:Dictionary={}
var celled
func ate_grass(graze_pos:Vector2):
	celled=local_to_map(graze_pos)
	cell_status=get_cell_atlas_coords(celled)
	if cell_status.x+1<=4:
		var new_cell=Vector2i(cell_status.x+1,cell_status.y)
		set_cell(celled,8,new_cell)
		##new cell
		cells_dic[celled]=new_cell
		##update cell if it exists
		###
		plant_state_manager(celled,120,new_cell)
func plant_state_manager(tile_pos,grass_time,atlas):
	#print(str(atlas))
	if atlas.x>0:
		await get_tree().create_timer(grass_time).timeout
		#print(str(cells_dic[tile_pos].x)+"atlas:"+str(atlas.x))
		if cells_dic[tile_pos].x == atlas.x:##check if grass changed
			set_cell(tile_pos,8,Vector2i(atlas.x-1,atlas.y))
			cells_dic[tile_pos]=Vector2i(atlas.x-1,atlas.y)
			plant_state_manager(tile_pos,grass_time,Vector2i(atlas.x-1,atlas.y))
	else:
		return
	#print(str(Vector2i(atlas.x-1,atlas.y)))
