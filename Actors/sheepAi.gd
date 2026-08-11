extends Sprite2D
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
@onready var grass_field:TileMapLayer=$"../GroundLayer2"
var t=0
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	roam()
	roam_destination=position
func _process(delta: float) -> void:
	t += delta * 0.01
	if state_roam==true:
		position=position.lerp(roam_destination,t*speed)
		if position.distance_to(roam_destination)<0.5:
			graze()
			position=roam_destination
			state_roam=false
			t=0
		
func roam():
	var dir=rng.randi_range(0,2)
	var dir_2=rng.randi_range(0,2)
	var dist=rng.randi_range(50,100)
	
	if dir==0:
		roam_destination.x=position.x
	if dir==1:
		roam_destination.x+=dist
	if dir==2:
		roam_destination.x-=dist
	if dir_2==0:
		roam_destination.y=position.y
	if dir_2==1:
		roam_destination.y+=dist
	if dir_2==2:
		roam_destination.y-=dist
	state_roam=true
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
	grass_field.ate_grass(position)
	#print(roam_destination)
