extends Area2D

@export var move_direction : Vector2 = Vector2(0,-70)
@export var move_speed : float = 40

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

func _ready():
	$AnimationPlayer.play("fly")

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	#if they reach the same point
	if global_position == target_pos:
		#if that point is the start position modify targe to desired position
		if target_pos == start_pos:
			target_pos = start_pos + move_direction
		#if that point is not the start position go to the starting position
		else:
			target_pos = start_pos
		


func _on_body_entered(body: Node2D) -> void:
	#this is to be sure it is the player specifically
	if not body.is_in_group("Player"):
		return
	body.take_damage(1)
	
	print("dela damage to player")
	
		 
		
