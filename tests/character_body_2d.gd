extends CharacterBody2D
var speed:int=30
var distance:int=10
var direction
var rng = RandomNumberGenerator.new()
var roam_destination:Vector2i
var moving:bool

func _ready() -> void:
	roam_stats()

func _process(delta: float) -> void:
	if moving:
		velocity = direction * speed
		move_and_slide()
		

func roam_stats():
	$pointers.show()
	$pointers.global_position=global_position
	var rng_time=rng.randi_range(1,3)
	await get_tree().create_timer(rng_time).timeout
	var rng_point=rng.randf_range(0.0,360.0)
	var random_x = randf_range(0.0, 500.0)
	var random_y = randf_range(0.0, 500.0)
	$pointers.global_position=Vector2(random_x,random_y)
	direction=global_position.direction_to($pointers.global_position).normalized()
	distance=rng.randi_range(50,100)
	$pointers.hide()
	moving=true
	$Timer.start(rng_time)

func _on_timer_timeout() -> void:
	moving=false
	roam_stats()
