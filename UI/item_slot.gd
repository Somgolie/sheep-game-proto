extends Panel

func set_item(item:item_resource,quantity:int):
	$TextureRect.texture=item.icon
	$Label.text=str(quantity)
