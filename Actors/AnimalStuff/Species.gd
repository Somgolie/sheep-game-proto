extends Resource
class_name Species
var Min:int
var Max:int

enum  Rare_Range{Common=1,Uncommon=2,Rare=3
,Unique=4,Exotic=5}
@export var Icon:Texture
@export var Name:String
@export var Base_Thickness:int
@export var Base_Curl:int
@export var Base_Color:Color
@export var Base_Health:int
@export var Max_Thickness:int
@export var Max_Curl:int
@export var Rare_Color:Color
@export var	Max_Health:int
@export var Growth_Rate:int
@export var stat_variation:int
@export var Market_Price:int
@export var Wool_Rarity:Rare_Range
#@export_group("Market_Price","Price_")
#@export var Price_Min:int
#@export var Price_Max:int
