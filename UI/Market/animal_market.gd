extends Control
@export var player_Animals:player_barn
@export var loot_table:Array[Species]
@export var Player_data:Player
@export var Game_Manager:game_manager
@export var rare_odds:int
@onready var Money=$Savings/TextureRect/Account
@onready var cards=$Cards
var card_amount:int=3

var Animals_sales:Array[Animal]

func _on_exit_pressed() -> void:
	close()
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Globals.update_available==true:
		update()
func update():
	Money.text=str(Player_data.PlayerSavings)
	Globals.update_available=false
func set_table():
	for n in card_amount:
		var picked_Speci=loot_table.pick_random()
		var New_Animal=Animal.new()
		##inherited qualities
		New_Animal.Name="Marya"
		New_Animal.Species_Type=picked_Speci
		New_Animal.Growth=picked_Speci.Growth_Rate
		##color sorting
		var rand_color=randi_range(0,100)
		if rand_color>(100-rare_odds):
			New_Animal.Wool_Color=picked_Speci.Rare_Color
		else:
			New_Animal.Wool_Color=picked_Speci.Base_Color
		##inherited+random
		var stat_var=randi_range(0,picked_Speci.stat_variation)
		New_Animal.Wool_Thickness=picked_Speci.Base_Thickness+stat_var
		
		stat_var=randi_range(0,picked_Speci.stat_variation)
		New_Animal.Wool_Curl=picked_Speci.Base_Curl+stat_var
		
		stat_var=randi_range(0,picked_Speci.stat_variation)
		New_Animal.Health=picked_Speci.Base_Health+stat_var
		
		##add to array:
		Animals_sales.append(New_Animal)
	##insert into the cards:
	for p in cards.get_child_count():
		cards.get_child(p).set_up(Animals_sales[p])


		
func open():
	$AnimationPlayer.play("Intro")
	if Animals_sales.size()==0:
		set_table()
	Money.text=str(Player_data.PlayerSavings)
	visible=true
func close():
	$AnimationPlayer.play_backwards("Intro")
