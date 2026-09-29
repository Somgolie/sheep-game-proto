extends Node2D
##states are: idle,grazing,roaming
##sheep roams to a random tile,then either idles or grazes 50% to graze again
##or roam
##check if grass is near
##choose random grass found
##eat grass
@export var produce:item_resource
var state_roam:bool
var state_graze:bool
var state_idle:bool
var roam_destination:Vector2
@export var speed:float
@export var grass_level:int
@export var grass_capacity:int
@export var grass_field:TileMapLayer
@onready var ghost=$Ghost
@export var manager:game_manager
@onready var playerinv=preload("res://UI/PlayerInv.tres")
var carry_mode:bool
var hover:bool
var out_of_bounds:bool
var t=0
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	grass_level=0
	hover=false
	carry_mode=false
	out_of_bounds=false
	state_roam=false
	$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.275)
	roam()
	roam_destination=global_position
func _process(delta: float) -> void:
	t += delta * 0.01
	if state_roam==true && carry_mode==false:
		$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.0)
		global_position=global_position.lerp(roam_destination,t*speed)
		if global_position.distance_to(roam_destination)<0.5:
			graze()
			global_position=roam_destination
			state_roam=false
			t=0
	if grass_level==grass_capacity:
		$TextureRect.visible=true
	else:
		$TextureRect.visible=false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Click")&& hover:
		if Globals.hand_tool:
			carry_mode=true
		else:
			if grass_level==grass_capacity:
				manager.add_to_inv(produce,1)
				grass_level=0
				

	if carry_mode:
		global_position=get_global_mouse_position()
	if Input.is_action_just_released("Click"):
		carry_mode=false
func roam():
	$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.275)
	ghost.global_position=global_position
	var dir=rng.randi_range(0,2)
	var dir_2=rng.randi_range(0,2)
	var dist=rng.randi_range(50,100)
	
	if dir==0:
		roam_destination.x=global_position.x
	if dir==1:
		roam_destination.x+=dist
	if dir==2:
		roam_destination.x-=dist
	if dir_2==0:
		roam_destination.y=global_position.y
	if dir_2==1:
		roam_destination.y+=dist
	if dir_2==2:
		roam_destination.y-=dist
	
	var prev_pos=ghost.global_position
	ghost.global_position=roam_destination
	await get_tree().create_timer(1).timeout
	if out_of_bounds==false:
		state_roam=true
	else:
		state_roam=false
		ghost.global_position=prev_pos
		graze()
		out_of_bounds=false
		return
	#if dist%2 !=0:
		#
	#else:
		#idle()
#func idle():
	#var secs=rng.randi_range(3,5)
	#await get_tree().create_timer(secs).timeout
	#roam()
func graze():
	await get_tree().create_timer(3).timeout
	roam()
	if grass_level<grass_capacity:
		grass_level+=1
		var pos=Vector2i(global_position.x+50,global_position.y)
		grass_field.ate_grass(pos)
	#print(roam_destination)



func _on_area_2d_area_entered(area: Area2D) -> void:
	pass





func _on_ghost_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Worldborder"):
		out_of_bounds=true
		#go back


func _on_ghost_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Worldborder"):
		out_of_bounds=false
		#go back


func _on_area_2d_mouse_entered() -> void:
	hover=true


func _on_area_2d_mouse_exited() -> void:
	hover=false
