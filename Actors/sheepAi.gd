extends CharacterBody2D
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
var roam_direction:Vector2
@export var ID:int
@export var speed:float
@export var grass_level:int
@export var grass_capacity:int
@export var grass_field:TileMapLayer
@onready var ghost=$Ghost
@export var manager:game_manager
@export var Info:Animal
@onready var playerinv=preload("res://Actors/PlayerStuff/PlayerInv.tres")
@export var max_speed:int=20
@export var accel:int=30
@export var friction:int=10
@export var outline:ShaderMaterial
var Tag_name:String
var carry_mode:bool
var hover:bool
var out_of_bounds:bool
var t=0
var rng = RandomNumberGenerator.new()
func _ready() -> void:

	#$Entity_Info.visible=false
	grass_level=0
	hover=false
	carry_mode=false
	out_of_bounds=false
	state_roam=false
	roam_destination=global_position
	$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.275)
	roam()
func set_default(id:int,Man:game_manager,Spe:int,capacity:int,field:TileMapLayer):
	speed=Spe
	ID=id
	grass_capacity=capacity
	grass_field=field
	manager=Man
func set_info(Info_list:Animal):
	$Sheepsvg1.texture=Info_list.Species_Type.Icon
	$Sheepsvg1.self_modulate=Info_list.Wool_Color
	Tag_name=Info_list.Name
func toggle_outline():
	if $Sheepsvg1.material==null:
		$Sheepsvg1.material=outline
	else:
		$Sheepsvg1.material=null
func _process(delta: float) -> void:
	if state_roam==true && carry_mode==false:
		#$Ghost.self_modulate=Color(0.02, 1.0, 1.0, 0.0)
		velocity = roam_direction * 30
		move_and_slide()
	if grass_level==grass_capacity:
		$TextureRect.visible=true
	else:
		$TextureRect.visible=false
func _physics_process(delta: float) -> void:
	#$AnimationPlayer.play("idle")
	###

	if Input.is_action_just_pressed("Click")&& hover:
		if Globals.current_tool!=null && Globals.current_tool.name=="Hand":
			carry_mode=true
			#$Entity_Info.visible=false
		if Globals.current_tool!=null && Globals.current_tool.name=="Shears":
			if grass_level==grass_capacity:
				manager.add_to_inv(produce,1)
				grass_level=0
				
	if Input.is_action_just_pressed("RightClick")&& hover:
		toggle_info()
	if carry_mode:
		Globals.holding_obj=true
		global_position=get_global_mouse_position()
	if Input.is_action_just_released("Click"):
		carry_mode=false
		Globals.holding_obj=false

func roam():
	ghost.show()
	ghost.global_position=global_position
	var rng_time=rng.randi_range(1,3)
	var rng_time_distance=rng.randi_range(1,10)
	await get_tree().create_timer(rng_time).timeout
	var rng_point=rng.randf_range(0.0,360.0)
	var random_x = randf_range(0.0, 500.0)
	var random_y = randf_range(0.0, 500.0)
	ghost.global_position=Vector2(random_x,random_y)
	roam_direction=global_position.direction_to(ghost.global_position).normalized()
	ghost.hide()
	state_roam=true
	if abs(roam_direction.x)!=roam_direction.x:
		$Sheepsvg1.flip_h=false
	else:
		$Sheepsvg1.flip_h=true

	$Timer.start(rng_time_distance)

func graze():
	await get_tree().create_timer(2).timeout
	roam()
	if grass_level<grass_capacity:
		grass_level+=1
		var pos=Vector2i(global_position.x+50,global_position.y)
		grass_field.ate_grass(pos)
	#print(roam_destination)

func toggle_info():
	if $Entity_Info.visible:
		$Entity_Info.visible=false
	else:
		$Entity_Info.visible=true

func _on_area_2d_mouse_entered() -> void:
	hover=true
	Globals.hover=Tag_name
func _on_area_2d_mouse_exited() -> void:
	hover=false
	Globals.hover=null

func _on_timer_timeout() -> void:
	state_roam=false
	graze()
