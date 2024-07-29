extends RigidBody2D
var hasHit : bool
const maxHealth : int = 2
var health
var color : String
var shooting : bool 
const shots : int = 4
const reload : int = 2
signal hit
signal fall

const FLAK_SCENE = preload("res://scenes/flak.tscn")
# Array of texture paths or preload the textures
var sprite_textures = [
	#preload("res://assets/blocks/white.png"),
	preload("res://assets/blocks/Tri/green.png"),
	preload("res://assets/blocks/Tri/blue.png"),
	preload("res://assets/blocks/Tri/red.png"),
	preload("res://assets/blocks/Tri/yellow.png")
]

func _ready():
	shooting = false
	health = maxHealth
	hasHit = false
	max_contacts_reported = 1
	contact_monitor = true
	randomize() # Ensure randomness
	var random_index = randi() % sprite_textures.size()
	var scale_factor = 0.8
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionPolygon2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor
	
func damage(amount):
	health -= amount
	if (health <= 0):
		apply_central_force(Vector2(0, 100))
		await get_tree().create_timer(0.25).timeout
		queue_free()

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

func _on_body_entered(body):
	hit.emit()
	if (hasHit):
		return
	hasHit = true
	var scale_factor = 1.2
	# make the collision shape slightly smaller while dropping to make error go in player's favor
	var collision_shape = $CollisionPolygon2D
	collision_shape.scale.x *= scale_factor
	collision_shape.scale.y *= scale_factor

func _process(delta):
	# check if the block is below the screen
	if (position.y > 700):
		hit.emit()
		fall.emit()
		# delete this instance
		queue_free()

func mount_defense():
	shooting = true
	while shooting:
		await get_tree().create_timer(randf()*reload).timeout
		if (!shooting):
			return
		for i in range(shots):
			var flak = FLAK_SCENE.instantiate()
			flak.linear_velocity = Vector2(700 + randf()*200,  -(randf()*600))
			add_child(flak)
		await get_tree().create_timer(reload).timeout


	
func stop_defense():
	shooting = false
