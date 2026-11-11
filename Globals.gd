extends Node
var hand_tool:bool
var holding_obj:bool
var current_tool:Tools
var update_available:bool
@onready var player_data=preload("res://Actors/PlayerStuff/PlayerSaveFile.tres")
var player_animals:Array[Animal]
var placing_obj
var following:bool
var hover
#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("reset"):
		#get_tree().reload_current_scene()
		#player_animals.clear()
