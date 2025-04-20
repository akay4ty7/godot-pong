extends Area2D

const SPEED = 300.0
const MAX_ANGLE_CHANGE = 60.0
var velocity = Vector2.ZERO  # Define velocity vector as 0
var initial_velocity = 1.0
var ball_speed_mod = 0
var viewport_size
var rand_angle = randf_range(-MAX_ANGLE_CHANGE, MAX_ANGLE_CHANGE)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialise both x and y components
	velocity = Vector2(1.0, 1.0) # Starting direction

	viewport_size = get_viewport_rect().size
	# Randomise initial direction
	if randf() > 0.5:
		velocity.x = -velocity.x
	if randf() > 0.5:
		velocity.y = -velocity.y
	print("Initial position: ", velocity.y, velocity.x)
	
	# Normalize and apply speed
	velocity = velocity.normalized() * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Update position directly
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	print("Collision into an object: ", body.name)
	print("Groups this body belongs to: ", body.get_groups())

	print("Body Transform: ", body.get_global_transform())
	
	
	if body.is_in_group("vertical_wall"):
		print("vertical_wall")
		velocity.x = -velocity.x
	if body.is_in_group("upper_wall"):
		print("upper_wall")
		print("Player Scores")
		random_start_position()
		# TODO: Create point system in relation to this for player.

	if body.is_in_group("lower_wall"):
		print("lower_wall")
		print("Enemy Scores")
		random_start_position()
		# TODO: Create point system in relation to this for enemy.
	if body.is_in_group("paddles"):
		print("paddles")
		
		# Get relative position where ball hit paddle
		var hit_position = position.x - body.global_position.x
		
		# Get paddle width (assuming the paddle has a CollisionShape2D as child)
		var paddle_width = 40  # Default value, replace with actual width
		if body.has_node("CollisionShape2D"):
			var collision = body.get_node("CollisionShape2D")
			
			if collision.shape is RectangleShape2D:
				paddle_width = collision.shape.extents.x * 2
				print("PADDLE WIDTH", paddle_width)
		
		# Normalize to value between -1 and 1
		var hit_factor = (hit_position / (paddle_width / 2))
		
		# Apply angle based on hit position
		var angle = hit_factor * MAX_ANGLE_CHANGE

		print("Angle: ", angle)

		if abs(angle) < (0.1 * MAX_ANGLE_CHANGE) && abs(angle) >= (0 * MAX_ANGLE_CHANGE):
			ball_speed_mod = SPEED * 1.75
		elif abs(angle) < (0.5 * MAX_ANGLE_CHANGE) && abs(angle) >= (0.1 * MAX_ANGLE_CHANGE):
			ball_speed_mod = SPEED * 1.25
		else:
			ball_speed_mod = SPEED * 0.75

		print("Modded Speed: ", ball_speed_mod)

		# speed mode sanity check
		if ball_speed_mod > SPEED * 1.75:
			ball_speed_mod = SPEED * 1.75
		elif ball_speed_mod < SPEED * 0.75:
			ball_speed_mod = SPEED * 0.75

		# Calculate new velocity direction
		velocity = Vector2(sin(deg_to_rad(angle)), -sign(velocity.y)).normalized() * ball_speed_mod
		

func random_start_position():
	position.x = randf_range(-(viewport_size.x / 2) + 20, (viewport_size.x / 2) - 20)
	position.y = 0.0

	print("Position x: ", position.x)
	print("Position y: ", position.y)
	
	# velocity.x = -velocity.x
	# velocity.y = -velocity.y
	velocity = Vector2(sin(deg_to_rad(rand_angle)), -sign(velocity.y)).normalized() * SPEED
