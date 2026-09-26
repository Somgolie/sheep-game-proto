extends TileMapLayer
@export var grass_tile:Array[int]
@export var flower_tile:Array[int]
var rand:RandomNumberGenerator

func _ready() -> void:
	var dimen=Vector2i(30,30)
	var atlas=Vector2i(0,0)
	for x in dimen.x:
		for y in dimen.y:
			var cell=Vector2i(x,y)
			var chosen_tile
			var varient
			var ran_tile=randi_range(0,180)
			if ran_tile>=100:
				continue
			else:
				if ran_tile>=76:
					##flower
					varient=randi_range(0,flower_tile.size())
					chosen_tile=flower_tile[varient-1]
					set_cell(cell,chosen_tile,atlas)
				else:
					##grass
					varient=randi_range(0,grass_tile.size())
					chosen_tile=grass_tile[varient-1]
					set_cell(cell,chosen_tile,atlas)
