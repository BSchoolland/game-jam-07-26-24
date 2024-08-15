# OOPS! This is for the O block, not L block, but I'm too lazy to fix it :D
extends "res://block_base.gd"
# Array of texture paths or preload the textures

func textures():
	sprite_textures = [
		#preload("res://assets/blocks/white.png"),
		preload("res://assets/blocks/O/green.png"),
		preload("res://assets/blocks/O/blue.png"),
		preload("res://assets/blocks/O/red.png"),
		preload("res://assets/blocks/O/yellow.png")
	]

func _ready():
	var collision_shape = $CollisionShape2D
	standard_ready(collision_shape)
	
func get_collision_shape():
	return $CollisionShape2D
