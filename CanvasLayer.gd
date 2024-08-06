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
	if (percentBetterThan == null):
		$"Better than".hide()
	else:
		$"Better than".show()
	$"Better than".text = "You did better than \n" + str(percentBetterThan) + "% of players"
	
func showLeaderBoardDay(list):
	var dailyString = ''
	for leader in list:
		dailyString += leader.initials + ": " + str(leader.score) + "\n"
	$Daily.text = dailyString
	
func showLeaderBoardAll(list):
	var dailyString = ''
	for leader in list:
		dailyString += leader.initials + ": " + str(leader.score) + "\n"
	$AllTime.text = dailyString
	

func _on_button_pressed():
	playAgain.emit()


func _on_button_2_pressed() -> void:
	goBack.emit()
