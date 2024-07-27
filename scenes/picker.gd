extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func random_cards():
	$Card.random_card()
	$Card2.random_card()
	$Card3.random_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
