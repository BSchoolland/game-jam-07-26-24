extends RigidBody2D
class_name Rocket

var hasHit : bool
var health
const power : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	hasHit = false
	max_contacts_reported = 1
	contact_monitor = true
	$AnimatedSprite2D.play("Flying")
	health = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if hasHit:
		return
	# Check if the body is of the same custom class type to prevent self-collision
	if body is Rocket:
		return
	body.damage(power)
	explode()

func explode():
	hasHit = true
	$AnimatedSprite2D.hide()
	$explosion.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func damage(amount):
	health -= 1
	if (health<=0):
		explode()
