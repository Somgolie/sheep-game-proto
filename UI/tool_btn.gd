extends Button
var tool_link:Tools

func setup_tool(tool:Tools):
	icon=tool.icon
	tool_link=tool



func _on_toggled(toggled_on: bool) -> void:
	
	if Globals.current_tool==tool_link:
		Globals.current_tool=null
		return
	Globals.current_tool=tool_link
