extends CharacterBody2D

var direction_x : float
@export_category('move')
@export var speed := 120
@export var acceleration : float = 600
@export var friction : float = 800

@export_category('jump')
# player jumping script
@export var jump_height: float = 100
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent)) * -1.0

#shooting signal
signal shoot(pos: Vector2, dir: Vector2)

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
		
func _get_input():
	#movement direction
	direction_x = Input.get_axis("left", "right")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity	
	if Input.is_action_just_pressed("shoot") and not $Timer/ReloadTimer.time_left:
		shoot.emit(position, get_local_mouse_position().normalized())
		$Timer/ReloadTimer.start()
	
## ------------------------ MOVEMENTd
func _move(delta):
	_get_input()
	
	# Movement speed
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Add the gravity.
	if not is_on_floor():
		velocity.y += _get_custom_gravity() * delta


func _get_custom_gravity() -> float:
	return jump_gravity if velocity.y > 0 else fall_gravity

## ------------------------ FUNCTION CALLER
func _physics_process(delta: float) -> void:
	_move(delta)
	_animation()

	move_and_slide()
