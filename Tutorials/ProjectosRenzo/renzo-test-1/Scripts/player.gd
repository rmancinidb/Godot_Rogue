# Character.gd
extends CharacterBody2D

var speed: float = 100.0

func add_speed(amount: float) -> void:
	speed += amount

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO  # Clears velocity for input recalculation
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x += speed
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= speed
	if Input.is_key_pressed(KEY_UP):
		velocity.y -= speed
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y += speed
	
	move_and_slide()
