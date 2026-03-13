extends Node2D

@export var player_scene : PackedScene
@export var player : CharacterBody2D
var player_array = []
var active_index = 0


func divide_players():
	var new_player = player_scene.instantiate()
	new_player.position = Vector2(player_array[active_index].position.x, player_array[active_index].position.y-10)
	new_player.sprite_size = player_array[active_index].sprite_size
	add_child(new_player)
	player_array.append(new_player)


func merge_players():
	var current_player = player_array[active_index]
	var merge_player = player_array[active_index].merging
	current_player.grow()
	player_array.erase(merge_player)
	active_index = player_array.find(current_player)
	merge_player.delete()

func switch_players():
	player_array[active_index].active = false
	if active_index+1 == player_array.size():
		active_index = 0
	else:
		active_index += 1
	player_array[active_index].active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.active = true
	player_array.append(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Area2D/Camera2D.position = $Player.position
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("divide"):
		if player_array[active_index].sprite_size > 0:
			player_array[active_index].shrink()
			divide_players()
			
	if event.is_action_pressed("merge"):
		if player_array.size() > 1 and player_array[active_index].merging:
			if player_array[active_index] == player_array[active_index].merging:
				return
			if player_array[active_index].sprite_size != player_array[active_index].merging.sprite_size:
				return
			if player_array[active_index].sprite_size+1 > PlayerManager.sprites.size():
				return
			merge_players()
			
	if event.is_action_pressed("switch"):
		if player_array.size() > 1:
			switch_players()
