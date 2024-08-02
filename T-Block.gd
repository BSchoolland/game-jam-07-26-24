extends "res://block_base.gd"
# Array of texture paths or preload the textures

func textures():
	sprite_textures = [
		#preload("res://assets/blocks/white.png"),
		preload("res://assets/blocks/T/green.png"),
		preload("res://assets/blocks/T/blue.png"),
		preload("res://assets/blocks/T/red.png"),
		preload("res://assets/blocks/T/yellow.png")
	]

func _ready():
	var collision_shape = $CollisionPolygon2D
	standard_ready(collision_shape)
	
func get_collision_shape():
	return $CollisionPolygon2D
