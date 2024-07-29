extends Node2D

var isGameRunning : bool
var isGameOver : bool
var score
var health
var cardCount : int
var blocks : Array
var activeBlock
var orientation : int
const FALL_SPEED : int = 50
const DROP_SPEED : int = 300
const MOVE_SPEED : int = 150

var isRightHeld : bool
var isLeftHeld : bool
var screen_size

var isBlockReady : bool

var rocketCount : int # the number of rockets to spawn per round

# Path to the scene to be instantiated
const L_BLOCK_SCENE = preload("res://scenes/L_block.tscn")
const J_BLOCK_SCENE = preload("res://scenes/j_block.tscn")
const O_BLOCK_SCENE = preload("res://o_block.tscn")
const T_BLOCK_SCENE = preload("res://t_block.tscn")
const CIRCLE_BLOCK_SCENE = preload("res://scenes/circle_block.tscn")
const Z_BLOCK_SCENE = preload("res://scenes/z_block.tscn")
const I_BLOCK_SCENE = preload("res://scenes/i_block.tscn")
const S_BLOCK_SCENE = preload("res://scenes/s_block.tscn")
const TRI_BLOCK_SCENE = preload("res://scenes/tri_block.tscn")
const ROCKET_SCENE = preload("res://scenes/rocket.tscn")
const FLOATING_TEXT_SCENE = preload("res://scenes/floating_text.tscn")

const HEART_SPRITE = preload("res://assets/heart.png")
const HEART_GONE_SPRITE = preload("res://assets/heart-gone.png")

const BLOCK_ARRAY = [
	L_BLOCK_SCENE,
	O_BLOCK_SCENE,
	T_BLOCK_SCENE,
	J_BLOCK_SCENE,
	Z_BLOCK_SCENE,
	S_BLOCK_SCENE,
	I_BLOCK_SCENE,
	CIRCLE_BLOCK_SCENE,
	TRI_BLOCK_SCENE
]

var forshadow_blocks : Array

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
	screen_size = get_viewport().size
	hide_picker()
	isGameOver = false
	isGameRunning = false
	health = 5
	score = 0
	rocketCount = 0
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
	pattern = []
	update_forshadow(true)
	cardCount = 0
	$picker.random_cards()
	$picker/Card.pick.connect(add_block)
	$picker/Card2.pick.connect(add_block)
	$picker/Card3.pick.connect(add_block)
	await get_tree().create_timer(0.5).timeout
	update_forshadow()
	#$picker.show()
	#$picker/Card.show()
#
	#$picker/Card2.show()
#
	#$picker/Card3.show()


func add_block(type, color):
	cardCount += 1
	print(type, color)
	var block
	if (type == 'O'):
		block = O_BLOCK_SCENE
	elif (type == 'T'):
		block = T_BLOCK_SCENE
	elif (type == "L"):
		block = L_BLOCK_SCENE
	elif (type == "J"):
		block = J_BLOCK_SCENE
	elif (type == "Z"):
		block = Z_BLOCK_SCENE
	elif (type == "S"):
		block = S_BLOCK_SCENE
	elif (type == "I"):
		block = I_BLOCK_SCENE
	else:
		block = TRI_BLOCK_SCENE
	pattern.push_back(
		{
			"block": block,
			"color": color
		}
	)
	if (cardCount >= 3):
		hide_picker()
		patternIndex = 0
		update_forshadow(true)
		spawn_block()

func clear_forshadow_blocks():
	$forshadow.hide()
	$forshadow2.hide()
	$forshadow3.hide()
	$forshadow4.hide()
	$forshadow5.hide()
	for block in forshadow_blocks:
		if (str(block) != "<Freed Object>"):
			block.queue_free()
	forshadow_blocks = []
		

func update_forshadow(skipWait = false):
	# clear the first block and remove it from the array
	if len(forshadow_blocks) > 0:
		if (str(forshadow_blocks[0]) != "<Freed Object>"):
			forshadow_blocks[0].queue_free()
		if (!skipWait):
			await get_tree().create_timer(1).timeout
	clear_forshadow_blocks()
	# use the current index and the pattern array to show upcomming blocks
	var i = patternIndex
	if (i >= len(pattern)):
		return
	# for now lets just do the next one
	var block
	block = pattern[i].block.instantiate()
	forshadow_blocks.append(block)
	block.set_color(pattern[i].color)
	$forshadow.load_block(block)
	$forshadow/Forshadow.hide()
	i += 1
	if (i >= len(pattern)):
		return
	block = pattern[i].block.instantiate()
	forshadow_blocks.append(block)
	block.set_color(pattern[i].color)
	$forshadow2.load_block(block)
	i += 1
	if (i >= len(pattern)):
		return
	block = pattern[i].block.instantiate()
	forshadow_blocks.append(block)
	block.set_color(pattern[i].color)
	$forshadow3.load_block(block)
	i += 1
	if (i >= len(pattern)):
		return
	block = pattern[i].block.instantiate()
	forshadow_blocks.append(block)
	block.set_color(pattern[i].color)
	$forshadow4.load_block(block)
	i += 1
	if (i >= len(pattern)):
		return
	block = pattern[i].block.instantiate()
	forshadow_blocks.append(block)
	block.set_color(pattern[i].color)
	$forshadow5.load_block(block)

func place_phase_end(skipWait = false):
	await rocket_phase(skipWait)
	patternIndex = 0
	update_forshadow(true)
	show_picker()


# Ensure that the ROCKET_SCENE is preloaded at the top of the script
# e.g.:
# @onready var ROCKET_SCENE = preload("res://path_to_your_rocket_scene.tscn")

func spawn_random_rocket():
	var new_rocket = ROCKET_SCENE.instantiate()
	
	# Get the viewport size to determine screen dimensions
	
	# Set the initial position slightly outside the right side of the screen
	var start_x = screen_size.x + 100  # Assuming the rocket's pivot point is at the center
	var y_array = []
	for block in blocks:
		if (str(block) != "<Freed Object>"):
			y_array.append(block.position.y)
	var random_index = randi() % y_array.size()
	var start_y = y_array[random_index]
	
	new_rocket.position = Vector2(start_x, start_y)
	
	# Apply a force to the left
	var force = Vector2(-200, 0)  # Adjust the value of the force as needed
	new_rocket.add_constant_central_force(force)
	
	# Add the rocket to the game (assuming the script is attached to the main scene node)
	add_child(new_rocket)


func rocket_phase(skipWait = false):
	#for block in blocks:
		#if (str(block) != "<Freed Object>"):
			#block.mount_defense()
	#
	#for n in range(rocketCount):
		#spawn_random_rocket()
		#await get_tree().create_timer(0.5).timeout
	#if (!skipWait):
		##await get_tree().create_timer(4).timeout
	#for block in blocks:
		#if (str(block) != "<Freed Object>"):
			#block.stop_defense()
	rocketCount += 0

func spawn_block(skipWait = false):
	if (!isGameRunning):
		return
	orientation = 0
	# Instance the scene
	if (patternIndex >= len(pattern)):
		place_phase_end(skipWait)
		return
	var falling_block = instantiate_pattern_block()
	patternIndex += 1
	# Set a random position within the screen bounds
	falling_block.position = Vector2(
		(screen_size.x * 0.5 ), 
		30  # Start from the top of the screen
	)
	activeBlock = falling_block
	activeBlock.hit.connect(handleActiveHit)
	activeBlock.fall.connect(handleFall)
	activeBlock.score.connect(score_points)
	blocks.append(activeBlock)
	# update foreshadow
	update_forshadow()
	# Add the instance to the scene tree
	call_deferred("add_child", falling_block)
	
func handleFall():
	if (!isGameRunning):
		return
	print('ouch sound here')
	health -= 1
	update_hearts()
	if (health <= 0 and !isGameOver):
		game_over()

func update_hearts():
	$Heart.texture = HEART_GONE_SPRITE
	$Heart2.texture = HEART_GONE_SPRITE
	$Heart3.texture = HEART_GONE_SPRITE
	$Heart4.texture = HEART_GONE_SPRITE
	$Heart5.texture = HEART_GONE_SPRITE
	if health > 0:
		$Heart.texture = HEART_SPRITE
	if health > 1:
		$Heart2.texture = HEART_SPRITE
	if health > 2:
		$Heart3.texture = HEART_SPRITE
	if health > 3:
		$Heart4.texture = HEART_SPRITE
	if health > 4:
		$Heart5.texture = HEART_SPRITE
func game_over():
	activeBlock = null
	print('game over')
	isGameRunning = false
	isGameOver = true
	$gameOverScreen.show()
	hide_picker()

func score_points(amount, body):
	if (!isGameRunning):
		return
	score += amount
	var floating_text_instance = FLOATING_TEXT_SCENE.instantiate()
	
	var label = floating_text_instance.get_node("Label")
	label.text = "+%s" % str(amount)
	
	# Set the position of the floating text to the body's position
	label.position = body.position + Vector2(-25, -75)

	
	# Add the floating text to the scene
	get_tree().current_scene.add_child(floating_text_instance)
	var tween = create_tween()
	await tween.tween_property(label, "position", body.position + Vector2(-25, -125), 1).finished

	floating_text_instance.queue_free()


func handleActiveHit():
	if (!isGameRunning):
		return
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


func start_game():
	if (isGameRunning):
		return
	for block in blocks:
		if (str(block) != "<Freed Object>"):
			block.queue_free()
	blocks = []
	$gameOverScreen.hide()
	isGameOver = false
	isGameRunning = true

	$"start-button".hide()
	hide_picker()
	health = 5
	update_hearts()
	score = 0
	rocketCount = 0
	orientation = 0
	patternIndex = 0
	# start the pattern with a blue square
	pattern = []
	update_forshadow(true)
	
	spawn_block(true)

func _on_startbutton_start():
	start_game()

func _on_game_over_screen_play_again():
	start_game()
