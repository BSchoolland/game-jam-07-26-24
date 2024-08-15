extends CanvasLayer

var myposition
# Called when the node enters the scene tree for the first time.
func _ready():
	myposition =  Vector2(575, 30)

func load_block(block):
	show()
	block.freeze = true
	call_deferred("add_child", block)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
