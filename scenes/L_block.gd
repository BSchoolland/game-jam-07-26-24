extends RigidBody2D

# Array of texture paths or preload the textures
var sprite_textures = [
	preload("res://assets/blocks/white.png"),
	#preload("res://assets/blocks/green.png"),
	preload("res://assets/blocks/blue.png"),
	preload("res://assets/blocks/red.png")
]

func _ready():
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var sprite_node = $sprite
	sprite_node.texture = sprite_textures[random_index]
