extends CanvasLayer

signal start
# Called when the node enters the scene tree for the first time.

func _on_button_pressed():
	start.emit()
