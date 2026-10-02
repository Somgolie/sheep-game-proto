extends Control
@export var max_water:int

@onready var playerinv=preload("res://Actors/PlayerStuff/PlayerInv.tres")
@onready var itemslot=preload("res://UI/item_slot.tscn")
@onready var playertools=preload("res://Actors/PlayerStuff/PlayerTools.tres")
@onready var toolslot=preload("res://UI/tool_btn.tscn")
@onready var slots=$inv_panel/HBoxContainer
@onready var displaytools=$inv_panel/tool_panel/HBoxContainer
@export var default_icon_slots:Texture2D
var slots_ar:Array[item_resource]
var water_amount:int
var watercan_active:bool
var shears_active:bool
func _ready() -> void:
	Globals.hand_tool=true
	water_amount=max_water
	slots_ar=[]
	setup_tools()
func update():
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
func setup_tools():
	for t in playertools.AllTools.size():
		var new_tool=toolslot.instantiate()
		new_tool.setup_tool(playertools.AllTools[t])
		displaytools.add_child(new_tool)
