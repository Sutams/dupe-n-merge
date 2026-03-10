extends CharacterBody2D


var active : bool
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var merging : Area2D
var size : int
var sizes = [1.5, 1.25, 1]
#var sizes = [1.5, 1.25, 1, 0.75, 0.5]

func _physics_process(delta: float) -> void:
	queue_redraw()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if active:
		# Handle jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _draw() -> void:
	if active:
		draw_rect(Rect2(10, -75, -25, -25),Color("Green"))
	else:
		draw_rect(Rect2(10, -75, -25, -25),Color("Red"))
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	merging = area


func _on_area_2d_area_exited(_area: Area2D) -> void:
	merging = null


func get_size():
	return size


func change_size(new_size: int) -> void:
	size = new_size
	self.scale = Vector2(sizes[size], sizes[size])
