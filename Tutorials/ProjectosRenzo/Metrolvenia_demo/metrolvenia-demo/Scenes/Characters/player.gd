extends CharacterBody2D

var direction_x : float
@export var speed := 120
var Jump_velocity: float = -400 

# player gun directions
const GUN_DIRECTIONS = {
	Vector2i(0,0):   0,
	Vector2i(1,0):   0,
	Vector2i(1,1):   1, 
	Vector2i(0,1):   2,
	Vector2i(-1,1):  3,
	Vector2i(-1,0):  4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1):  6,
	Vector2i(1,-1):  7,
}


### ----------------------- ANIMATION
func _animation():
	#legs
	if direction_x != 0:
		$Sprite/LegsSprite.flip_h = direction_x < 0
	if is_on_floor():
		$AnimationPlayer.current_animation = 'Run' if direction_x else 'idle'
	else: 
		$AnimationPlayer.current_animation = 'Jump'
		
	#Torso
	var raw_dir = get_local_mouse_position().normalized()
	var adjusted_dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Sprite/TorsoSprite.frame = GUN_DIRECTIONS[adjusted_dir]
		
		
## ------------------------ MOVEMENT
func _move(delta):
	direction_x = Input.get_axis("left", "right")
	
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = Jump_velocity	


## ------------------------ FUNCTION CALLER
func _physics_process(delta: float) -> void:
	_move(delta)
	_animation()

	move_and_slide()
