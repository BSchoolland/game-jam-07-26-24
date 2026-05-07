extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func earthquake():
	$AudioStreamPlayer.play(0.5)
	await get_tree().create_timer(3).timeout

	var shake_duration: float = 3.0
	var shake_intensity: float = 5.0
	var elapsed_time = 0
	var original_position = position
	while elapsed_time < shake_duration:
		var shake_x = randf_range(-shake_intensity, shake_intensity)
		var shake_y = randf_range(-shake_intensity, shake_intensity)
		position = original_position + Vector2(shake_x, shake_y)
		elapsed_time += 0.05
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(2).timeout
	shake_intensity *= 0.5
	while elapsed_time < shake_duration / 2:
		var shake_x = randf_range(-shake_intensity, shake_intensity)
		var shake_y = randf_range(-shake_intensity, shake_intensity)
		position = original_position + Vector2(shake_x, shake_y)
		elapsed_time += 0.05
		await get_tree().create_timer(0.05).timeout
	

  
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(amount):
	pass
