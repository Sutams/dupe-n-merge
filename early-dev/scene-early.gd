extends Node2D

var player_scene
var player
var blobs : Array[Node2D]
var current_active : int
var root

# Called the first time
func _ready() -> void:
	root = get_tree().get_root()
	
	player_scene = load("res://early-dev/player-early.tscn")
	
	player = player_scene.instantiate()
	root.add_child.call_deferred(player)
	
	blobs.append(player)
	current_active=0
	blobs[current_active].active = true
	blobs[current_active].translate(Vector2(500,500))
	blobs[current_active].change_size(0)


# Called every frame
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("divide")):
		if blobs[current_active].get_size()+1 < blobs[0].sizes.size():
			
			blobs.append(player_scene.instantiate())
			root.add_child.call_deferred(blobs.back())
			
			var new_size = blobs[current_active].get_size()+1
			blobs[current_active].change_size(new_size)
			blobs[current_active].active = false
			
			blobs.back().translate(blobs[current_active].position+Vector2(50,0))
			blobs.back().change_size(new_size)
			current_active = blobs.size()-1
			blobs[current_active].active = true
		pass
	
	if(Input.is_action_just_pressed("switch")):
		if blobs.size()>1:
			blobs[current_active].active = false
			if blobs[current_active] == blobs.back():
				current_active=0
			else:
				current_active=current_active+1
			blobs[current_active].active = true
			print(blobs[current_active])
			pass
		pass
	
	if(Input.is_action_just_pressed("merge") and blobs[current_active].merging):
		var current_player = blobs[current_active]
		var merge_player = blobs[current_active].merging.get_parent()
		
		if current_player.size == merge_player.get_size():
			var i = 0
			for blob in blobs:
				if blob != merge_player:
					i = i+1
				else:
					blobs.pop_at(i).free()
					current_active = blobs.find(current_player)
					blobs[current_active].change_size(current_player.size-1)
		pass
