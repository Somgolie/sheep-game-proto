extends Control
@export var Player_data:Player

@onready var growth=$InfoPanel/MainInfo/growth
@onready var Health=$InfoPanel/MainInfo/stats/Health
@onready var Curl=$InfoPanel/MainInfo/stats/Curl
@onready var Thickness=$InfoPanel/MainInfo/stats/Thickness
@onready var Specie=$InfoPanel/MainInfo/SpecieName
@onready var Gender=$InfoPanel/Gender
@onready var Icon=$AnimalIcon
@onready var Price_tag=$PriceTag/TextureRect/Price
var bought:bool
var Item:Animal
var price:int
func _physics_process(delta: float) -> void:
	if price>Player_data.PlayerSavings:
		Price_tag.modulate=Color(1.0, 0.137, 0.329)
		$Buying.modulate=Color(1.0, 1.0, 1.0, 0.416)
		$Buying.disabled=true
	else:
		Price_tag.modulate=Color(1.0, 1.0, 1.0, 1.0)
		$Buying.modulate=Color(1.0, 1.0, 1.0, 1.0)
		if !bought:
			$Buying.disabled=false
func set_up(input:Animal):
	bought=false
	Item=input
	growth.text="Growth "+str(input.Growth)+"X"
	Specie.text=input.Species_Type.Name
	Icon.texture=input.Species_Type.Icon
	Icon.self_modulate=input.Wool_Color
	price=calc_price(input)
	Price_tag.text=str(price)
	##health
	Health.value=input.Health
	$InfoPanel/MainInfo/stats/Health/min.text=str(input.Health)
	$InfoPanel/MainInfo/stats/Health/max.text=str(input.Species_Type.Max_Health)
	##Curl
	Curl.value=input.Wool_Curl
	$InfoPanel/MainInfo/stats/Curl/min.text=str(input.Wool_Curl)
	$InfoPanel/MainInfo/stats/Curl/max.text=str(input.Species_Type.Max_Curl)
	##Thickness
	Thickness.value=input.Wool_Thickness
	$InfoPanel/MainInfo/stats/Thickness/min.text=str(input.Wool_Thickness)
	$InfoPanel/MainInfo/stats/Thickness/max.text=str(input.Species_Type.Max_Thickness)
func buy(price:int,item):
	if price<=Player_data.PlayerSavings:
		Player_data.PlayerSavings-=price
		if item is Animal:
			Player_data.PlayerAnimals.Animal_list[0]=item
		modulate=Color(0.412, 0.412, 0.412)
		bought=true
		$AnimationPlayer.play("Bought")
		$Buying.disabled=true
		Globals.update_available=true
func not_enough():
	pass##je'ne compron pas "signals"

func calc_price(item):
	if item is Animal:
		var value=item.Species_Type.Market_Price
		value+=item.Health+item.Wool_Curl+item.Wool_Thickness
		
		if item.Wool_Color==item.Species_Type.Rare_Color:
			value+=item.Species_Type.Market_Price*item.Species_Type.Wool_Rarity
		if item.Growth>1:
			value*=item.Growth
		return value
	else:
		##for now
		return 0
func _on_buying_pressed() -> void:
	buy(price,Item)
