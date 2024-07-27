extends RigidBody2D
var hasHit : bool
signal hit
signal fall
# Array of texture paths or preload the textures
var sprite_textures = [
	#preload("res://assets/blocks/white.png"),
	preload("res://assets/blocks/C/green.png"),
	preload("res://assets/blocks/C/blue.png"),
	preload("res://assets/blocks/C/red.png"),
	preload("res://assets/blocks/C/yellow.png")
]

func _ready():
	hasHit = false
	max_contacts_reported = 1
	contact_monitor = true
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var sprite_node = $sprite
	sprite_node.texture = sprite_textures[random_index]
	var scale_factor = 0.8
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionShape2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor

func _on_body_entered(body):
	hit.emit()
	if (hasHit):
		return
	hasHit = true
	var scale_factor = 1.2
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionShape2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor

func _process(delta):
	# check if the block is below the screen
	if (position.y > 700):
		hit.emit()
		fall.emit()
		# delete this instance
		queue_free()
