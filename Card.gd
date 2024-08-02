extends CanvasLayer
var type : String
var color : String
var display_block

const types : Array = [
	'O',
	'L',
	'T',
	'J',
	"Z",
	"S",
	"I"
	#'Tri'
]

const colors : Array = [
	'red',
	'green',
	'blue',
	'yellow'
]

# Path to the scene to be instantiated
const L_BLOCK_SCENE = preload("res://scenes/L_block.tscn")
const J_BLOCK_SCENE = preload("res://scenes/j_block.tscn")
const O_BLOCK_SCENE = preload("res://o_block.tscn")
const T_BLOCK_SCENE = preload("res://t_block.tscn")
const Z_BLOCK_SCENE = preload("res://scenes/z_block.tscn")
const S_BLOCK_SCENE = preload("res://scenes/s_block.tscn")
const I_BLOCK_SCENE = preload("res://scenes/i_block.tscn")
const CIRCLE_BLOCK_SCENE = preload("res://scenes/circle_block.tscn")
const TRI_BLOCK_SCENE = preload("res://scenes/tri_block.tscn")

func random_card(first = true):
	if (display_block):
		display_block.queue_free()
	# Seed the random number generator to ensure randomness
	randomize()
	
	# Get random indices for the types and colors arrays
	var random_type_index = randi() % types.size()
	var random_color_index = randi() % colors.size()
	
	# Set the type and color to the randomly selected values
	type = types[random_type_index]
	color = colors[random_color_index]
	# show the block chosen
	var block
	if (type == "O"):
		block = O_BLOCK_SCENE
	elif (type == "L"):
		block = L_BLOCK_SCENE
	elif (type == "J"):
		block = J_BLOCK_SCENE
	elif (type == "Tri"):
		block = TRI_BLOCK_SCENE
	elif (type == "T"):
		block = T_BLOCK_SCENE
	elif (type == "Z"):
		block = Z_BLOCK_SCENE
	elif (type == "S"):
		block = S_BLOCK_SCENE
	elif (type == "I"):
		block = I_BLOCK_SCENE
	else:
		print('ERROR: BLOCK UNDEFINED')
	var block_instance = block.instantiate()
	block_instance.set_color(color)
	block_instance.position = Vector2(0, -100)
	block_instance.gravity_scale = 0
	freeze_rigidbody(block_instance)
	display_block = block_instance
	call_deferred("add_child", block_instance)
	if (first):
		await get_tree().create_timer(0.25).timeout
		pick.emit(type, color)
		random_card(false)
# signal for the card being chosen

func freeze_rigidbody(rigidbody: RigidBody2D):
	rigidbody.freeze = true

signal pick
# Called when the node enters the scene tree for the first time.
func _ready():
	type = 'O'
	color = 'red'
	display_block = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	pick.emit(type, color)
