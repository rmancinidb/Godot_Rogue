extends CharacterBody2D

# ---------- Tunable values (show up in the Inspector) ----------
@export var move_speed : float = 200.0          # → top horizontal speed
@export var acceleration : float = 600          # → how fast we reach move_speed
@export var braking : float = 1200              # → how fast we slow to 0 when no input
@export var gravity_multiplier : float = 1      # → scales the global gravity locally
@export var jump_force : float = 300.0          # → upward impulse on jump
@export var normal_friction : float = 1         # → default friction for normal ground

@export var health : int = 3

var move_input : float                          # → -1 (left), 0 (idle), or +1 (right)

#onready means when the game start
@onready var sprite : Sprite2D = $sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
# independet of the frame per second (make physics consistent)
func _physics_process(delta: float) -> void:

	# ---------- gravity and floor conditions ----------
	# I like to use the built-in function get_gravity:
	#   global magnitude:  ProjectSettings.set_setting("physics/2d/default_gravity", 1500.0)
	#   global direction:  ProjectSettings.set_setting("physics/2d/default_gravity_vector", Vector2(0, -1))
	#   local override:    multiply get_gravity() by a factor (like below)
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multiplier   # → only pull down while airborne


	# ---------- friction elements ----------
	var current_friction: float = normal_friction   # → assume normal ground first
	if is_on_floor():
		# get_floor_tile_friction() is a personalized function (esta al final)
		current_friction = get_floor_tile_friction()   # → overwrite with the tile's value


	# ---------- movement conditions ----------
	# Input.get_axis("move_left", "move_right")
	# the left is a negative input and the right is a positive input
	move_input = Input.get_axis("move_left", "move_right")

	# este if and else make it more general the movement active or inactive
	if move_input != 0:
		# → there IS input: speed up toward the target direction
		var target_speed : float = move_input * move_speed
		# two different functions can be used here:
		#   move_toward(from, to, delta): constant linear rate — precise, responsive, hits the target cleanly.
		#                                 Good for tight platformers, fighting games, precision movement.
		#   lerp(from, to, weight): decaying exponential rate — smooth, momentum-heavy, tapers near the target,
		#                           never fully reaches 0 or max. Good for ice, drifting cars, camera follow.
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		# → no input: brake toward 0. friction scales HOW hard we brake
		# this part is the braking, thats why friction is important
		# (lo agrege arriba porque tambien deberia ser relevante cuando empiezas a moverte)
		velocity.x = move_toward(velocity.x, 0, (braking * current_friction) * delta)



	# ---------- jumping ----------
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force        # → negative y is up


	# this one actually makes the character move:
	# takes the velocity vector and handles collision detection
	move_and_slide()

## FUNCTIONS

# _proccess is a built-in virtual method in Godot that runs every single frame
func _process(delta):
	#it is true or false
	if velocity.x !=0 :
		sprite.flip_h = velocity.x > 0
		
	_manage_animation()	

#it need to be called in the procces function
func _manage_animation ():
	if not is_on_floor():
		anim.play("jump")
	elif move_input !=0:
		anim.play("one_move")
	else:
		anim.play('idle')
	
func take_damage (amount : int):
	health -= amount
	
	if health <= 0:
		#call_deferred wait until the fram is ended
		call_deferred("game_over")
		
func game_over ():
	get_tree().change_scene_to_file("res://Scene/level1.tscn")
	

func increase_score (amount : int):
	PlayerStats.score += amount
	print(PlayerStats.score)

# ---------- Helper: read the friction of the tile we're standing on ----------
func get_floor_tile_friction() -> float:
	# get_slide_collision_count(): how many things we touched during the last move_and_slide()
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)     # → one collision from that list
		var collider := collision.get_collider()    # → the object we hit

		# only tiles carry friction data — skip enemies, walls, etc.
		if collider is TileMapLayer:
			var tilemap: TileMapLayer = collider

			# → the contact point sits on the seam between us and the tile,
			#   so push it a bit downward to land INSIDE the floor tile
			var nudge = tilemap.tile_set.tile_size.y * 0.25          # → quarter-tile, scales with tile size
			var floor_point = collision.get_position() + Vector2(0, nudge)

			# → convert that world point into a tile coordinate, then grab its data
			var cell = tilemap.local_to_map(tilemap.to_local(floor_point))
			var tile_data := tilemap.get_cell_tile_data(cell)

			if tile_data:
				var custom_f = tile_data.get_custom_data("friction")
				# → note: the "> 0.0" means a tile painted with exactly 0 is ignored
				#   and falls back to normal_friction. Fine for now, just be aware.
				if custom_f != null and float(custom_f) > 0.0:
					return float(custom_f)

	return normal_friction   # → nothing valid found: use the default
