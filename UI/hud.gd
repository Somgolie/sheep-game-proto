extends Control
@export var max_water:int
@onready var watercan_label=$watercan/Label
@onready var watercan=$watercan
var water_amount:int
var watercan_active:bool

func _ready() -> void:
	water_amount=max_water
	update()
func update():
	watercan_label.text=str(water_amount)+"/"+str(max_water)
func _on_watercan_toggled(toggled_on: bool) -> void:
	watercan_active=toggled_on
