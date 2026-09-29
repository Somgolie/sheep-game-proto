extends TileMapLayer
@export var root:Node2D
var cell_status:Vector2i
var cells_dic:Dictionary={}
var Allgrass_Level:Dictionary={}
var celled
var grass_count:int
var max_grass_count:float
@onready var grass_layer=$"../GrassLayer"
@export var grass_dimensions:Vector2i
@export var field_type:FieldTable
func _ready() -> void:

	max_grass_count=(field_type.green_space/100.0)*grass_dimensions.x
	grass_count=max_grass_count
	for i in grass_dimensions.x:
		for j in grass_dimensions.y:
			set_cell(Vector2i(i,j),8,Vector2i(0,2))
			Allgrass_Level[Vector2i(i,j)]=grass_layer.set_a_grass(Vector2i(i,j))
			if Allgrass_Level[Vector2i(i,j)]>0 && grass_count>0:
				grass_count-=1
			##send to grass layer set grassfunc
	$Timer.start(randi_range(1,5))
func ate_grass(graze_pos:Vector2):
	celled=local_to_map(graze_pos)
	cell_status=get_cell_atlas_coords(celled)
	if cell_status.x+1<=4:
		if Allgrass_Level[celled]==field_type.richness:
			grass_layer.remove_a_grass(celled)
			Allgrass_Level[celled]=0
			if grass_count<max_grass_count:
				grass_count+=1
		else:
			var new_cell=Vector2i(cell_status.x+1,cell_status.y)
			set_cell(celled,8,new_cell)
			##new cell
			cells_dic[celled]=new_cell##cels ground status
			Allgrass_Level[celled]-=1
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
			if Allgrass_Level[tile_pos]<0:
				Allgrass_Level[tile_pos]+=1
			plant_state_manager(tile_pos,grass_time,Vector2i(atlas.x-1,atlas.y))
	else:
		return
	#print(str(Vector2i(atlas.x-1,atlas.y)))


func _on_timer_timeout() -> void:
	var chance=(grass_count/max_grass_count)*100
	for i in grass_dimensions.x:
		for j in grass_dimensions.y:
			if Allgrass_Level[Vector2i(i,j)]>=0 && Allgrass_Level[Vector2i(i,j)]<field_type.richness:
				Allgrass_Level[Vector2i(i,j)]+=1
				if Allgrass_Level[Vector2i(i,j)]==field_type.richness:
					var roll=randi_range(0,100)
					##low grasscount==low chance
					if roll<=chance && grass_count!=max_grass_count:
						Allgrass_Level[Vector2i(i,j)]=grass_layer.set_a_grass(Vector2i(i,j))
					else:
						Allgrass_Level[Vector2i(i,j)]=0
	$Timer.start(randi_range(30,60))
