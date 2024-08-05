extends CanvasLayer

signal playAgain
signal goBack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func displayScore(score, percentBetterThan):
	$Score.text = "Score: " + str(score)
	$"Better than".text = "You did better than: " + str(percentBetterThan) + "% of players"

func _on_button_pressed():
	playAgain.emit()


func _on_button_2_pressed() -> void:
	goBack.emit()
