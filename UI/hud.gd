extends Control
@export var max_water:int

@export var manager:game_manager
@onready var playerinv=preload("res://Actors/PlayerStuff/PlayerInv.tres")
@onready var itemslot=preload("res://UI/item_slot.tscn")
@onready var playertools=preload("res://Actors/PlayerStuff/PlayerTools.tres")
@onready var toolslot=preload("res://UI/tool_btn.tscn")

@onready var displaytools=$inv_panel/tool_panel/HBoxContainer
@onready var invUI=$InvUI
@onready var inv_container=$InvUI.inv_container
@export var default_icon_slots:Texture2D
@export var camera:Node
var slots_ar:Array[item_resource]
var water_amount:int
var watercan_active:bool
var shears_active:bool
func _ready() -> void:
	Globals.hand_tool=true
	water_amount=max_water
	slots_ar=[]
	setup_tools()
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Bag"):
		invUI.visible=!invUI.is_visible_in_tree()
func update():
	var foundlike=false
	for i in playerinv.inv.size():
		if playerinv.inv[i]!=null:
			if playerinv.inv[i].item_in !=null:
				for j in slots_ar.size():
					if slots_ar[j]==playerinv.inv[i].item_in:
						inv_container.get_child(j).set_item(playerinv.inv[i].item_in,playerinv.inv[i].amount)
						foundlike=true
				##create the slots
				if !foundlike:
					slots_ar.resize(slots_ar.size()+1)
					slots_ar[-1]=playerinv.inv[i].item_in
					var new_slot=itemslot.instantiate()
					new_slot.set_item(playerinv.inv[i].item_in,playerinv.inv[i].amount)
					inv_container.add_child(new_slot)
func setup_tools():
	for t in playertools.AllTools.size():
		var new_tool=toolslot.instantiate()
		new_tool.setup_tool(playertools.AllTools[t])
		displaytools.add_child(new_tool)


func _on_sheep_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$SheepButton/AnimationPlayer.play("Info_Slide")
	else:
		$SheepButton/AnimationPlayer.play_backwards("Info_Slide")


#func _on_market_button_toggled(toggled_on: bool) -> void:
	#if toggled_on:
		#$AnimalMarket.open()
		#toggled_on=false
	#else:
		#$AnimalMarket.close()


func _on_market_button_pressed() -> void:
	if !$AnimalMarket.visible:
		$AnimalMarket.open()
