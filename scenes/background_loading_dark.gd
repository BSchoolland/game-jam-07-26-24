extends CanvasLayer

signal select1
signal select2
signal select3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.


func _on_select_1_pressed() -> void:
	select1.emit()


func _on_select_2_pressed() -> void:
	select2.emit()


func _on_select_3_pressed() -> void:
	select3.emit()
