extends Control
@export var max_water:int
@onready var watercan_label=$tool_panel/HBoxContainer/watercan/Label
@onready var watercan=$tool_panel/HBoxContainer/watercan
@onready var shears=$tool_panel/HBoxContainer/Shears
@onready var playerinv=preload("res://UI/PlayerInv.tres")
@onready var itemslot=preload("res://UI/item_slot.tscn")
@onready var slots=$inv_panel/HBoxContainer
@export var default_icon_slots:Texture2D
var slots_ar:Array[item_resource]
var water_amount:int
var watercan_active:bool
var shears_active:bool
func _ready() -> void:
	Globals.hand_tool=true
	water_amount=max_water
	slots_ar=[]

func update():
	watercan_label.text=str(water_amount)+"/"+str(max_water)
	var foundlike=false
	for i in playerinv.inv.size():
		if playerinv.inv[i]!=null:
			if playerinv.inv[i].item_in !=null:
				for j in slots_ar.size():
					if slots_ar[j]==playerinv.inv[i].item_in:
						slots.get_child(j).set_item(playerinv.inv[i].item_in,playerinv.inv[i].amount)
						foundlike=true
				##create the slots
				if !foundlike:
					slots_ar.resize(slots_ar.size()+1)
					slots_ar[-1]=playerinv.inv[i].item_in
					var new_slot=itemslot.instantiate()
					new_slot.set_item(playerinv.inv[i].item_in,playerinv.inv[i].amount)
					slots.add_child(new_slot)


func _on_watercan_toggled(toggled_on: bool) -> void:
	watercan_active=toggled_on


func _on_shears_toggled(toggled_on: bool) -> void:
	shears_active=toggled_on
	Globals.hand_tool=!toggled_on
	print(shears_active)
