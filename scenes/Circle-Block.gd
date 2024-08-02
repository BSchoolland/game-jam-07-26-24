extends RigidBody2D

signal hit
# Array of texture paths or preload the textures
var sprite_textures = [
	#preload("res://assets/blocks/white.png"),
	preload("res://assets/blocks/C/green.png"),
	preload("res://assets/blocks/C/blue.png"),
	preload("res://assets/blocks/C/red.png")
]

func _ready():
	max_contacts_reported = 1
	contact_monitor = true
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var sprite_node = $sprite
	sprite_node.texture = sprite_textures[random_index]

func _on_body_entered(body):
	hit.emit()
