extends RigidBody2D
const maxHealth : int = 2
var health
var color : String
var hasHit : bool
var matchingConnected : Array
var directConnections : Array
var hasFallen : bool
signal hit
signal fall
signal score
# Array of texture paths or preload the textures
var sprite_textures = [
	#preload("res://assets/blocks/white.png"),
	preload("res://assets/blocks/L/green.png"),
	preload("res://assets/blocks/L/blue.png"),
	preload("res://assets/blocks/L/red.png"),
	preload("res://assets/blocks/L/yellow.png")
]

func damage(amount):
	health -= amount
	if (health <= 0):
		apply_central_force(Vector2(0, 100))
		await get_tree().create_timer(0.25).timeout
		queue_free()

func _ready():
	hasFallen = false
	matchingConnected = [self]
	health = maxHealth
	hasHit = false
	max_contacts_reported = 10
	contact_monitor = true
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var scale_factor = 0.8
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionPolygon2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor

func set_color(new_color):
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

func merge_arrays_no_duplicates(array1, array2):
	var combined_array = array1 + array2
	var unique_array = []
		
	for item in combined_array:
		if item not in unique_array:
			unique_array.append(item)
		
	return unique_array

func _on_body_entered(body):

	if body is RigidBody2D:
		if body.color == color:
			match_body(body)
	var previous = [] + matchingConnected
	hit.emit()
	if (hasHit):
		return
	hasHit = true
	var scale_factor = 1.2
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionPolygon2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor
	await get_tree().create_timer(0.15).timeout
	if (len(matchingConnected) > len(previous)):
		score.emit(len(matchingConnected), self)
		light_up_matching(matchingConnected)
	else:
		score.emit(len(previous), self)
		light_up_matching(previous)

func light_up_matching(list) -> void:
	if (len(list) == 1):
		return
	for body in list:
		if (str(body) != "<Freed Object>"):
			highlight_sprite(body.get_node("sprite"))

@export var shake_intensity: float = 10.0

func highlight_sprite(sprite: Sprite2D) -> void:
	print('go')
	var original_scale = sprite.scale
	var enlarged_scale = original_scale * 1.2
	var tween = create_tween()
	
	# Enlarge the sprite
	await tween.tween_property(sprite, "scale", enlarged_scale, 0.1).finished
	# Return the sprite to its original size
	tween = create_tween()
	await tween.tween_property(sprite, "scale", original_scale, 0.05).finished
	
	

func match_body(body):
	directConnections = merge_arrays_no_duplicates(directConnections, [body])
	matchingConnected = merge_arrays_no_duplicates(directConnections, matchingConnected)
	matchingConnected = merge_arrays_no_duplicates(body.matchingConnected, matchingConnected)
	
func _on_body_exited(body):
	if body is RigidBody2D:
		if body.color == color:
			directConnections.erase(body)
			matchingConnected = [self]
			for block in directConnections:
				match_body(block)


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



