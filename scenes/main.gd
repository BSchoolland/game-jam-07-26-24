extends Node2D

# Path to the scene to be instantiated
const FALLING_BLOCK_SCENE = preload("res://scenes/L_block.tscn")

func _ready():
	pass

func _on_spawn_timer_timeout():
	# Instance the scene
	var falling_block = FALLING_BLOCK_SCENE.instantiate()
	
	# Set a random position within the screen bounds
	var screen_size = get_viewport().size
	falling_block.position = Vector2(
		(screen_size.x * 0.4 + randi() % int(screen_size.x * 0.2)), 
		0  # Start from the top of the screen
	)
	
	# Add the instance to the scene tree
	add_child(falling_block)

func _process(delta):
	# Make sure the random number generator is seeded
	randomize()
