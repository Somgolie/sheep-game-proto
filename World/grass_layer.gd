extends TileMapLayer
@export var grass_tile:Array[int]
@export var flower_tile:Array[int]
@export var field_type:FieldTable
var grass_count:int
var rand:RandomNumberGenerator

#func _ready() -> void:
	#initiate_grassland(Vector2i(30,30))
func set_a_grass(pos:Vector2i):
	var atlas=Vector2i(0,0)
	var grassORnot=randi_range(0,100)
	if grassORnot<=field_type.green_space:
		#add plant
		var pickedplant=randi_range(0,100)##100%
		var plant_list=field_type.plant_table
		for x in plant_list.size():
			if pickedplant<=plant_list[x].chance:
				##found the plant now to set it
				var varient=plant_list[x].plant.ID.pick_random()
				set_cell(pos,varient,atlas)
				return field_type.richness
	else:
		##empty grass
		return 0

func remove_a_grass(pos:Vector2i):
	erase_cell(pos)
