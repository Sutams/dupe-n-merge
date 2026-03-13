extends CharacterBody2D

@export var active : bool = false
@export var sprite : Sprite2D
@export var sprite_size : int = 0
@export var coll_small : CollisionShape2D
@export var coll_medium : CollisionShape2D
@export var coll_big : CollisionShape2D
@export var merge_coll_small : CollisionShape2D
@export var merge_coll_medium : CollisionShape2D
@export var merge_coll_big : CollisionShape2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const AIR_TIME = 0.35
var jump_time = AIR_TIME
var merging : CharacterBody2D = null
#var is_on_floor : bool = false

func change_collider():
	#if i wanna deal with way bigger colls, theres a formula to determine shape size dinamically (make it)
	var colliders = [coll_small, coll_medium, coll_big]
	var merge_colliders = [merge_coll_small, merge_coll_medium, merge_coll_big] 
	for coll in colliders:
		coll.set_deferred("disabled", true)
	for coll in merge_colliders:
		coll.set_deferred("disabled", true)
	colliders[sprite_size].set_deferred("disabled", false)
	merge_colliders[sprite_size].set_deferred("disabled", false)
	


func grow():
	sprite_size += 1
	sprite.texture = load(PlayerManager.sprites[sprite_size])
	change_collider()

func shrink():
	sprite_size -= 1
	sprite.texture = load(PlayerManager.sprites[sprite_size])
	change_collider()

func delete():
	queue_free()

func _ready() -> void:
	sprite.texture = load(PlayerManager.sprites[sprite_size])
	change_collider()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if jump_time < 0:
			velocity += get_gravity() * delta
		else:
			jump_time -= 0.1
	else:
		jump_time = AIR_TIME

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
	queue_redraw()


func _draw() -> void:
	if active:
		draw_rect(Rect2(1, 0, -2, 20),Color("Green"))
	else:
		draw_rect(Rect2(1, 0, -2, 20),Color("Red"))
	pass


func _on_merge_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		merging = body


func _on_merge_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		merging = null
