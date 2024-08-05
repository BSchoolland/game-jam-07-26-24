extends RigidBody2D

var color : String
var hasHit : bool
var Connections : Array
var hasFallen : bool
var groupsize = 0
signal hit
signal fall
signal score
signal stop_check_completed
var sprite_textures = []

func get_collision_shape():
	# this will be overwritten in the derived class
	print("Base class collision shape method called")
	return

func textures():
	# This will be overridden in the derived class
	print("Base class textures method called")
# Called when the node enters the scene tree for the first time.
func set_color(new_color):
	textures()
	var sprite_node = $sprite
	color = new_color
	match new_color:
		'green':
			sprite_node.texture = sprite_textures[0]
		'blue':
			sprite_node.texture = sprite_textures[1]
		'red':
			sprite_node.texture = sprite_textures[2]
		'yellow':
			sprite_node.texture = sprite_textures[3]
		_:
			print("Invalid color")
			

func standard_ready(collision_shape):
	hasFallen = false
	Connections = [self]
	hasHit = false
	max_contacts_reported = 10
	contact_monitor = true
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var scale_factor = 0.8
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor

func merge_arrays_no_duplicates(array1, array2):
	var combined_array = array1 + array2
	var unique_array = []
		
	for item in combined_array:
		if item not in unique_array:
			unique_array.append(item)
		
	return unique_array
var waiting_for_stop : bool = false


func _physics_process(delta):
	if waiting_for_stop:
		if (linear_velocity.abs()[0] + linear_velocity.abs()[1]) < 1:
			waiting_for_stop = false
			emit_signal("stop_check_completed")

func stop_check() -> Signal:
	while waiting_for_stop:
		await get_tree().process_frame
	return stop_check_completed

func light_up_matching(dict) -> void:
	if dict.size() == 1:
		return
	for body in dict:
		if str(body) != "<Freed Object>":
			highlight_sprite(body.get_node("sprite"))

@export var shake_intensity: float = 10.0

func highlight_sprite(sprite: Sprite2D) -> void:

	var original_scale = sprite.scale
	var enlarged_scale = original_scale * 1.2
	var tween = create_tween()
	
	# Enlarge the sprite
	await tween.tween_property(sprite, "scale", enlarged_scale, 0.1).finished
	# Return the sprite to its original size
	tween = create_tween()
	await tween.tween_property(sprite, "scale", original_scale, 0.05).finished
	


func match_body(body):
	Connections = merge_arrays_no_duplicates(Connections, [body])
	
func unmatch_body(body):
	Connections.erase(body)

# Define the function to find all connected nodes
func find_all_connected(start_node):
	var visited = {}
	_find_all_connected_recursive(start_node, visited)

	return visited
	
# Helper recursive function to perform DFS
func _find_all_connected_recursive(node, visited):
	if node in visited:
		return
	visited[node] = true
	for neighbor in node.Connections:
		_find_all_connected_recursive(neighbor, visited)


func _on_body_entered(body: Node):

	if body is RigidBody2D:
		if body.color == color:
			match_body(body)
			body.match_body(self)
	hit.emit()
	if hasHit:
		return
	hasHit = true
	var scale_factor = 1.2
	# Make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = get_collision_shape()
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor
	await get_tree().create_timer(0.1).timeout
	waiting_for_stop = true
	await stop_check()
	# again rig it in the player's favor by giving them two chances to score, 0.1 seconds apart, and give them the higher number of the two
	var previous_group = find_all_connected(self)
	await get_tree().create_timer(0.1).timeout
	var group = find_all_connected(self)
	if (previous_group.size() > group.size()):
		group = previous_group
	score.emit(group.size(), self)
	light_up_matching(group)
	groupsize = group.size()

	
func _on_body_exited(body):
	if body is RigidBody2D:
		if body.color == color:
			unmatch_body(body)
			body.unmatch_body(self)


func _process(delta):
	# check if the block is below the screen
	if (position.y > 700 and !hasFallen):
		hasFallen = true
		hit.emit()
		fall.emit()
		await get_tree().create_timer(4).timeout
		# delete this instance
		queue_free()

func mount_defense():
	pass
	
func stop_defense():
	pass
