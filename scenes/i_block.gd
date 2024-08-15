extends "res://block_base.gd"
# Array of texture paths or preload the textures

# defefines base class func
func textures():
	sprite_textures = [
		#preload("res://assets/blocks/white.png"),
		preload("res://assets/blocks/I/green.png"),
		preload("res://assets/blocks/I/blue.png"),
		preload("res://assets/blocks/I/red.png"),
		preload("res://assets/blocks/I/yellow.png")
	]

func _ready():
	var collision_shape = $CollisionShape2D
	standard_ready(collision_shape)
	
func get_collision_shape():
	return $CollisionShape2D
