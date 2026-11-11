extends Button
var tool_link:Tools
var base:Texture
var clicked:Texture
var hover:Texture
signal changed_tool(tool)
@export var default_tool:Tools
func setup_tool(tool:Tools):
	icon=tool.icon
	tool_link=tool



func _on_toggled(toggled_on: bool) -> void:
	if Globals.current_tool==tool_link:
		Globals.current_tool=default_tool
		return
	Globals.current_tool=tool_link
	Input.set_custom_mouse_cursor(Globals.current_tool.icon)
