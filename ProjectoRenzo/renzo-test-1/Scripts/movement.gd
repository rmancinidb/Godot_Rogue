extends Sprite2D

var speed : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0,0)
	
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position += Vector2(1,1) * delta * speed
	
