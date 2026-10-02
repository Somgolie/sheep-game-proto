extends Camera2D
const ZOOM_INCREMENT = 0.05
const ZOOM_MIN = 0.5
const ZOOM_MAX = 2.0

var edge_panning := false
var mouse_panning:= false
var zoom_level := 1.0
var threshold=5 #edge size
var step=4#pan speed
var pan_direction:Array
var left_press:=false
var target_zoom = Vector2(1, 1)
var ZOOM_SPEED=10.0
var zooming:=false
var zoom_mouse_world := Vector2.ZERO
var zoom_mouse := Vector2.ZERO
@onready var viewport_size = get_viewport().size
@onready var edge_graphic=$ScreenEdges/edge_Graphic
#change the entire thing

func _ready() -> void:
	pan_direction=[0,0]
	Globals.holding_obj=false
	#GlobalEvents.highlighted_obj=false

func _process(delta: float) -> void:
	var mouse_pre := to_local(
		get_canvas_transform().affine_inverse().basis_xform(zoom_mouse)
	)
	zoom = lerp(zoom, target_zoom, ZOOM_SPEED * delta)
	var mouse_post := to_local(
		get_canvas_transform().affine_inverse().basis_xform(zoom_mouse)
	)
	global_position += mouse_pre - mouse_post
	if Globals.holding_obj:##if holding obj no mousepanning
		mouse_panning=false
		edge_panning=true
		edge_graphic.visible=true
		edge_graphic.modulate=Color(1.0, 1.0, 1.0, 1.0)
		#Edge_Panning code/////
		if pan_direction[0]!=0:
			position.y += step*pan_direction[0] ##up and down
		if pan_direction[1]!=0:
			position.x += step*pan_direction[1] ##left and right
		#//////
		#print("edge_panning enabled")

	if Globals.holding_obj==false:
		mouse_panning=true
		edge_panning=false
		edge_graphic.visible=false
	else:
		mouse_panning=false
		edge_panning=false
		edge_graphic.visible=false




func _unhandled_input(_event:InputEvent) -> void:
	if _event is InputEventMouseButton and _event.pressed:
		if _event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_mouse = get_viewport().get_mouse_position()
			zoom_mouse -= get_viewport_rect().size * 0.5
			set_zoom_target(ZOOM_INCREMENT)

		elif _event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_mouse = get_viewport().get_mouse_position()
			zoom_mouse -= get_viewport_rect().size * 0.5
			set_zoom_target(-ZOOM_INCREMENT)
			#//////
	#MousePanCode////
	elif _event is InputEventMouseMotion and mouse_panning:
		get_tree().get_root().set_input_as_handled()
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			global_position -= _event.relative / zoom_level
	#/////
func set_zoom_target(amount:float) -> void:
	zoom_level = clamp(zoom_level + amount, ZOOM_MIN, ZOOM_MAX)
	target_zoom = zoom_level * Vector2.ONE
	zooming=true

#pan direction handling/////
func _on_detect_top_mouse_entered() -> void:
	pan_direction[0]=-1
func _on_detect_top_mouse_exited() -> void:
	pan_direction[0]=0


func _on_detect_bottom_mouse_entered() -> void:
	pan_direction[0]=1
func _on_detect_bottom_mouse_exited() -> void:
	pan_direction[0]=0


func _on_detect_left_mouse_entered() -> void:
	pan_direction[1]=-1
func _on_detect_left_mouse_exited() -> void:
	pan_direction[1]=0


func _on_detect_right_mouse_entered() -> void:
	pan_direction[1]=1
func _on_detect_right_mouse_exited() -> void:
	pan_direction[1]=0
#//////////////////////////
