extends Panel
@export var Animals:player_barn
@onready var health=$VBoxContainer/Health
@onready var curl=$VBoxContainer/Curl
@onready var thickness=$VBoxContainer/Thickness
@onready var info_texture=$Icon
@onready var info_name=$Name
@export var food_tex:Texture2D
@export var empty_icon:Texture2D
@export var no_name:String
@export var edit_icon:Texture2D
@export var edit_done_icon:Texture2D
@export var add_icon:Texture2D
@export var remove_icon:Texture2D
@export var HUD:Node
var editing_name:bool
var current:int
var list:Array[Animal]
var select:bool
var select_hover:bool
var ID:int
@export var to_field:Button
func _ready() -> void:
	
	list=[]
	current=0
	$Icon.material
	select=false
	select_hover=false
func _process(delta: float) -> void:
	if visible:
		if Globals.player_animals.size()==0:
			set_empty()

	if list.size()<Globals.player_animals.size():
		list=Globals.player_animals
		set_barn(0)
	
func _physics_process(delta: float) -> void:
	if select_hover && Input.is_action_just_pressed("Click"):
		Globals.placing_obj=list[current]
		select_hover=false


func set_barn(index:int):
	select=false
	select_hover=false
	
	if list.size()-1>=current:
		if Globals.player_animals[index].ID==0:
			ID+=1
			Globals.player_animals[index].ID=ID
		
		to_field.visible=true
		$Edit.icon=edit_icon
		info_texture.texture=list[index].Species_Type.Icon
		info_name.text=list[index].Name
		info_texture.self_modulate=list[index].Wool_Color
		health.visible=true
		health.value=list[index].Health
		curl.value=list[index].Wool_Curl
		curl.visible=true
		thickness.value=list[index].Wool_Thickness
		thickness.visible=true
		if list[index].on_field:
			to_field.icon=remove_icon
			to_field.text="Remove"
		else:
			to_field.icon=add_icon
			to_field.text="Add"
		$VBoxContainer2.visible=true
		#health
		$VBoxContainer/Health/min.text=str(list[index].Health)
		$VBoxContainer/Health/max.text=str(list[index].Species_Type.Max_Health)
		#curl
		$VBoxContainer/Curl/min.text=str(list[index].Wool_Curl)
		$VBoxContainer/Curl/max.text=str(list[index].Species_Type.Max_Curl)
		#thickness
		$VBoxContainer/Thickness/min.text=str(list[index].Wool_Thickness)
		$VBoxContainer/Thickness/max.text=str(list[index].Species_Type.Max_Thickness)


func set_empty():
	ID=0
	select=false
	info_texture.texture=empty_icon
	info_name.text=no_name
	$Icon.texture=empty_icon
	health.visible=false
	thickness.visible=false
	curl.visible=false
	$VBoxContainer2.visible=false
	to_field.visible=false

func _on_next_pressed() -> void:
	if current==list.size()-1:
		current=0
	else:
		current+=1
	set_barn(current)
	Globals.following=false
	return


func _on_prev_pressed() -> void:
	if current==0:
		current=list.size()-1
	else:
		current-=1
	set_barn(current)
	Globals.following=false
	return


func _on_name_text_changed() -> void:
	editing_name=true
	$Edit.icon=edit_done_icon


func _on_edit_toggled(toggled_on: bool) -> void:
	editing_name=false
	$Edit.icon=edit_icon
	Globals.player_animals[current].Name=$Name.text


#func _on_area_2d_mouse_entered() -> void:
	#$AnimationPlayer.play("pointer")
	#select_hover=true
	#$Area2D/CollisionShape2D/TextureRect.visible=true
#
#func _on_area_2d_mouse_exited() -> void:
	#$AnimationPlayer.stop()
	#select_hover=false
	#$Area2D/CollisionShape2D/TextureRect.visible=false


func _on_to_field_pressed() -> void:
	if list[current].on_field:##if on field remove
		HUD.ask_remove_entity(list[current].ID)
		to_field.icon=add_icon
		to_field.text="Add"
		list[current].on_field=false
	else:
		HUD.ask_add_entity(list[current])
		to_field.icon=remove_icon##if not field add
		to_field.text="Remove"
		list[current].on_field=true




func _on_view_toggled(toggled_on: bool) -> void:
	if Globals.following==false:
		HUD.ask_focus_on_node(list[current].ID)
	else:
		Globals.following=true
