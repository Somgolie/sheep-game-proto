extends CharacterBody2D
const max_speed:int=300
const accel:int=30
const friction:int=10

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("Right")-Input.get_action_strength("Left"),
		Input.get_action_strength("Down")-Input.get_action_strength("Up")
	).normalized()

	
	var lerp_weight=delta*(accel if input else friction)
	velocity = lerp(velocity,input*max_speed,lerp_weight)
	
	if input:
		if input.x < 0:
			$Icon.flip_h=false
		else:
			$Icon.flip_h=true
	move_and_slide()
