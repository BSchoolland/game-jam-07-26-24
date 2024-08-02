extends RigidBody2D
var hasHit : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	hasHit = false
	print('flak spawned')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if hasHit:
		return
	# Check if the body is of the same custom class type to prevent self-collision
	if body is Rocket:
		hasHit = true
		body.damage(1)
		
func damage(amount):
	pass
