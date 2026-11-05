extends Node2D
class_name game_manager
@export var sheep_source:Node
@export var Animal_node:Node
@onready var playerinv=preload("res://Actors/PlayerStuff/PlayerInv.tres")
@export var hud:Control
@export var Player_data:Player
@export var canvas:CanvasLayer
@export var mouse_obj:Node
@onready var sheep_base=preload("res://Actors/sheep.tscn")
@export var field_graze:TileMapLayer
@export var camera:Camera2D
var placeing_obj

func _ready() -> void:
	placeing_obj=null
	Globals.placing_obj=null
	for n in playerinv.inv.size():
		playerinv.inv[n].item_in=null
		playerinv.inv[n].amount=0
func _process(delta: float) -> void:
	if placeing_obj==null&&Globals.placing_obj !=null:
		hud.placing_obj()
		placeing_obj=Globals.placing_obj

func add_to_inv(item:item_resource,amount:int):
	var founditem=false
	for n in playerinv.inv.size():
		if playerinv.inv[n].item_in==item:
			playerinv.inv[n].amount+=amount
			hud.update()
			founditem=true
	if founditem==false:
		playerinv.inv[-1].item_in=item
		playerinv.inv[-1].amount=amount
		hud.update()
func increase_to_inv(item_index:int,amount:int):
	pass
func update_hud():
	hud.update()

func remove_entity(child_id):
	for n in Animal_node.get_child_count():
		if Animal_node.get_child(n).ID==child_id:
			Animal_node.get_child(n).queue_free()
			return
	print(str(child_id))

func add_entity(entity:Animal):
	var new_ani=sheep_base.instantiate()
	new_ani.set_info(entity)
	##spe:0.0 cap:0.0
	#set_default(id:int,Man:game_manager,Spe:int,capacity:int,field:TileMapLayer)
	new_ani.set_default(entity.ID,self,1.0,5.0,field_graze)
	Animal_node.add_child(new_ani)
	new_ani.global_position=sheep_source.global_position
func focus_on_node(child_id):
	for n in Animal_node.get_child_count():
		if Animal_node.get_child(n).ID==child_id:
			var f_node=Animal_node.get_child(n)
			camera.focus_on_node(f_node,0.5)
			Globals.following=true
