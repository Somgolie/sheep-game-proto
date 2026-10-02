extends Node2D

@export var manager:game_manager
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func  _ready() -> void:
	Globals.holding_obj=false
