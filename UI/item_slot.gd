extends Panel
@export var hover:Texture2D
@export var normal:Texture2D
var style2 : StyleBoxTexture

func _ready() -> void:
	style2  = StyleBoxTexture.new()
	style2.texture=normal
	add_theme_stylebox_override ("panel", style2)
func set_item(item:item_resource,quantity:int):
	$TextureRect.texture=item.icon
	$Label.text=str(quantity)



func _on_area_2d_mouse_entered() -> void:
	style2.texture=hover
	add_theme_stylebox_override ("panel", style2)
func _on_area_2d_mouse_exited() -> void:
	style2.texture=normal
	add_theme_stylebox_override ("panel", style2)


func _on_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
