extends Area2D

var rotate_speed : float = 3.0
var bob_hight :float = 5.0
var bob_speed :float = 5.0

@onready var start_pos : Vector2 = global_position
@onready var sprite : Sprite2D = $Sprite

#we create physics process because we want collition on it
func _physics_process(delta: float):
# this give the unit time a big number ion seconds.
	var time = Time.get_unix_time_from_system()
	
	#rotate
	sprite.scale.x = sin(time * rotate_speed)
	
	# bob up and down
	var y_pos = (1 + sin(time * bob_speed) /2) * bob_hight
	global_position.y = start_pos.y - y_pos
	
func _on_body_entered(body: Node2D):
	if not body.is_in_group("Player"):
		return
	
	body.increase_score(1)
	queue_free()
