extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const AIR_TIME = 0.35
var jump_time = AIR_TIME
var is_on_floor : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor:
		if jump_time < 0:
			velocity += get_gravity() * delta
		else:
			jump_time -= 0.1
	else:
		jump_time = AIR_TIME

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if is_on_floor:
		$Area2D/Landing.debug_color = Color("Green")
	else:
		$Area2D/Landing.debug_color = Color("Red")

#extends Node2D
#
#var speed = 200
#var jump_speed = 200
#var air_time = 0.3
#var on_floor = false
#var gravity = 50
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var dir = Input.get_axis("left","right")
	#var jump = Input.is_action_pressed("up")
	#position.x += dir * speed * delta
	#
	#if on_floor:
		#if jump and air_time > 0:
			#print("jump")
			#position.y -= jump_speed * delta
			#air_time -= 0.1
	#else:
		#position.y += gravity * delta
		##air_time = 0.3 #when touches floor
#
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("divide"):
		print("divide")
	if event.is_action_pressed("merge"):
		print("merge")
	if event.is_action_pressed("switch"):
		print("switch")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "TileMapLayer":
		is_on_floor = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "TileMapLayer":
		is_on_floor = false
