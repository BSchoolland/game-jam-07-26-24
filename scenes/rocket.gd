extends RigidBody2D
class_name Rocket

var hasHit : bool
var health
const color : String = 'none'
# Called when the node enters the scene tree for the first time.
func _ready():
	hasHit = false
	max_contacts_reported = 1
	contact_monitor = true
	$AnimatedSprite2D.play("Flying")
	health = 1
	$Fly.play()
	await get_tree().create_timer(6).timeout
	explode()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if hasHit:
		return
	# Check if the body is of the same custom class type to prevent self-collision
	if body is Rocket:
		return
	body.damage(1)
	explode()

func explode():
	$Fly.stop()
	$Boom.play(1)
	hasHit = true
	$AnimatedSprite2D.hide()
	$explosion.play()
	await get_tree().create_timer(1).timeout
	queue_free()

func damage(amount):
	health -= 1
	if (health<=0):
		explode()
