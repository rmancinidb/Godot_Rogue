extends CharacterBody2D


@export var move_speed : float = 100.0
@export var acceleration : float = 50
@export var breaking : float = 20
@export var gravity_multiplayer : float = 1
@export var jump_force : float = 300.0

var move_input : float

#independet of the fram per second (make physics consistent)
func _physics_process(delta: float) -> void:
	
# --------	movement conditions --------------
	
# Input.get_axis("move_left", "move_right")
# the left is a negative input and the right is a positive input
	move_input = Input.get_axis("move_left", "move_right")

#este if and else hace make it more general the movement active or inactive
	if move_input != 0:
		var target_speed : float = move_input * move_speed
# two different functions can be use here:
	# move_toward(from, to, delta(acceleration*delta): it is exact I choose the frames- Changes values at a constant linear rate, providing precise, responsive, and predictable movement that hits target values cleanly. Tight platformers, fighting games, precision movement. 
	# lerp(from, to, weight): it smooths the movement depending of the amount to reach - Changes values at a decaying exponential rate, providing smooth, organic, and momentum-heavy movement that tapers off near the target., never reach 0 or max Ice levels, drifting cars, smooth camera follow, space shooters.
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, breaking * delta)
	
	
	
	
# --------	gravcity and floor conditions --------------	
	
#I like to use the build in function get_gravity:
#To modify global gravity magnitude
#ProjectSettings.set_setting("physics/2d/default_gravity", 1500.0)
#To modify  global gravity direction (e.g., pulling upward)
# ProjectSettings.set_setting("physics/2d/default_gravity_vector", Vector2(0, -1))
# it also can be do it locally by multiplying get gravity for a factor
# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multiplayer


# --------	jumping --------------

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force


# this one actuali make the character to move
#take velocity vector and implement colition detection
	move_and_slide()
