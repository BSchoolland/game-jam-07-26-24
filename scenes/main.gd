extends Node2D

var isGameRunning : bool
var isGameOver : bool
var score
var health

var blocks : Array
var activeBlock
var orientation : int
const FALL_SPEED : int = 50
const DROP_SPEED : int = 300
const MOVE_SPEED : int = 150

var isRightHeld : bool
var isLeftHeld : bool

var isBlockReady : bool

# Path to the scene to be instantiated
const L_BLOCK_SCENE = preload("res://scenes/L_block.tscn")
const O_BLOCK_SCENE = preload("res://o_block.tscn")
const T_BLOCK_SCENE = preload("res://t_block.tscn")
const CIRCLE_BLOCK_SCENE = preload("res://scenes/circle_block.tscn")
const TRI_BLOCK_SCENE = preload("res://scenes/tri_block.tscn")

const BLOCK_ARRAY = [
	L_BLOCK_SCENE,
	O_BLOCK_SCENE,
	T_BLOCK_SCENE,
	CIRCLE_BLOCK_SCENE,
	TRI_BLOCK_SCENE
]

var pattern : Array

var patternIndex : int

func instantiate_random_block() -> RigidBody2D:
	# Get a random index from the BLOCK_ARRAY
	var random_index = randi() % BLOCK_ARRAY.size()
	# Instantiate the selected block scene
	var block_instance = BLOCK_ARRAY[random_index].instantiate()
	block_instance.position = Vector2(100, 100) # will be changed
	return block_instance

func instantiate_pattern_block() -> RigidBody2D:
	# get the next block in the pattern
	var block_info = pattern[patternIndex]
	var block_instance = block_info.block.instantiate()
	block_instance.set_color(block_info.color)
	return block_instance

func _ready():
	hide_picker()
	isGameOver = false
	isGameRunning = false
	health = 3
	score = 0
	orientation = 0
	set_process_input(true) 
	pattern = []
	patternIndex = 0
	start_game()
	
func hide_picker():
	$picker.hide()
	$picker/Card.hide()
	$picker/Card.pick.disconnect(add_block)
	$picker/Card2.hide()
	$picker/Card2.pick.disconnect(add_block)
	$picker/Card3.hide()
	$picker/Card3.pick.disconnect(add_block)
	
func show_picker():
	$picker.random_cards()
	$picker.show()
	$picker/Card.show()
	$picker/Card.pick.connect(add_block)
	$picker/Card2.show()
	$picker/Card2.pick.connect(add_block)
	$picker/Card3.show()
	$picker/Card3.pick.connect(add_block)

func add_block(type, color):
	print(type, color)
	var block
	if (type == 'O'):
		block = O_BLOCK_SCENE
	elif (type == 'T'):
		block = T_BLOCK_SCENE
	elif (type == "L"):
		block = L_BLOCK_SCENE
	else:
		block = TRI_BLOCK_SCENE
	pattern.push_back(
		{
			"block": block,
			"color": color
		}
	)
	
	hide_picker()
	patternIndex = 0
	spawn_block()

func spawn_block():
	if (!isGameRunning):
		return
	orientation = 0
	# Instance the scene
	if (patternIndex >= len(pattern)):
		await get_tree().create_timer(1.0).timeout
		show_picker()
		return
	var falling_block = instantiate_pattern_block()
	patternIndex += 1
	# Set a random position within the screen bounds
	var screen_size = get_viewport().size
	falling_block.position = Vector2(
		(screen_size.x * 0.4 + randi() % int(screen_size.x * 0.2)), 
		0  # Start from the top of the screen
	)
	activeBlock = falling_block
	activeBlock.hit.connect(handleActiveHit)
	activeBlock.fall.connect(handleFall)
	# Add the instance to the scene tree
	call_deferred("add_child", falling_block)

func handleFall():
	if (!isGameRunning):
		return
	score -= 1
	print('ouch sound here')
	health -= 1
	if (health <= 0):
		print('game over')
		isGameRunning = false
		isGameOver = true
		

func handleActiveHit():
	if (!isGameRunning):
		return
	score += 1
	activeBlock.hit.disconnect(handleActiveHit)
	activeBlock = null
	spawn_block()

func _process(delta):
	# slow down the active block if it's going faster than fall speed
	$Score.text = "Score: " + str(score)
	$Health.text = "Lives: " + str(health)
	
func _physics_process(delta):
	if (!isGameRunning):
		return
	if activeBlock:
		var velocity = activeBlock.linear_velocity
		if Input.is_key_pressed(KEY_RIGHT):
			# move the activeBlock somewhat to the right
			velocity.x = MOVE_SPEED
		elif Input.is_key_pressed(KEY_LEFT):
			# move to the left
			velocity.x = -MOVE_SPEED
		else:
			velocity.x = 0
		if Input.is_key_pressed(KEY_DOWN):
			if activeBlock.linear_velocity.y > DROP_SPEED:
				velocity.y = DROP_SPEED
		elif activeBlock.linear_velocity.y > FALL_SPEED:
			velocity.y = FALL_SPEED
		activeBlock.linear_velocity = velocity
		
		# try to orient the block based on the orientation variable
		rotate_block_to_orientation(activeBlock, orientation)
const ROTATE_SPEED : int = 5
func rotate_block_to_orientation(block, orientation):
	rotate_block_to_angle(block, orientation * (PI / 2))
	
func rotate_block_to_angle(block: RigidBody2D, target_orientation: float):
	# Current orientation of the block
	var current_orientation = block.rotation
	# Calculate the difference between the current and target orientation
	var difference = target_orientation - current_orientation
	# Normalize the difference to the range [-PI, PI]
	difference = wrapf(difference, -PI, PI)
	# Set the angular velocity based on the difference
	block.angular_velocity = difference * ROTATE_SPEED

func _input(event):
	if event is InputEventKey and event.pressed and (event.keycode == KEY_R or event.keycode == KEY_UP):
		orientation += 1
		if orientation > 3:
			orientation = 0
		print(orientation)

func start_game():
	if (isGameRunning):
		return
	print('ok')
	isGameRunning = true

	$"start-button".hide()
	# start the pattern with a blue square
	pattern = [
		{
			"block": O_BLOCK_SCENE,
			"color": 'blue'
		 }
	]
	
	spawn_block()

func _on_startbutton_start():
	start_game()
