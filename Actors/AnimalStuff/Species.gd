extends Resource
class_name Species
var Min:int
var Max:int

enum  Rare_Range{Common=50,Uncommon=25,Rare=12
,Unique=6,Exotic=1}
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

@export_group("AnimationFrames","Frame_")
@export var Frame_Idle1:Texture
@export var Frame_Idle2:Texture
@export var Frame_Sleep1:Texture
