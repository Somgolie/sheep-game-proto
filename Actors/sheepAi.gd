extends Node2D
##states are: idle,grazing,roaming
##sheep roams to a random tile,then either idles or grazes 50% to graze again
##or roam
##check if grass is near
##choose random grass found
##eat grass
var state_roam:bool
var state_graze:bool
var state_idle:bool
var roam_destination:Vector2
@export var speed:float
@export var grass_field:TileMapLayer
@onready var ghost=$Ghost
var out_of_bounds:bool
var t=0
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	out_of_bounds=false
	state_roam=false
	$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.275)
	roam()
	roam_destination=global_position
func _process(delta: float) -> void:
	t += delta * 0.01
	if state_roam==true:
		$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.0)
		global_position=global_position.lerp(roam_destination,t*speed)
		if global_position.distance_to(roam_destination)<0.5:
			graze()
			global_position=roam_destination
			state_roam=false
			t=0
		
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
	grass_field.ate_grass(global_position)
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
