extends Node2D
class_name game_manager
@onready var playerinv=preload("res://Actors/PlayerStuff/PlayerInv.tres")
@export var hud:Control
func _ready() -> void:
	for n in playerinv.inv.size():
		playerinv.inv[n].item_in=null
		playerinv.inv[n].amount=0
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
