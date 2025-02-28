extends Area2D

var velocity = Vector2.ZERO  # Define velocity vector as 0
var initial_velocity = 1.0
const SPEED = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialise both x and y components
	velocity = Vector2(1.0, 1.0) # Starting direction
	
	# Randomise initial direction
	if randf() > 0.5:
		velocity.x = -velocity.x
	if randf() > 0.5:
		velocity.y = -velocity.y
	
	# Normalize and apply speed
	velocity = velocity.normalized() * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Update position directly
	position += velocity * delta

func _on_body_entered(body:Node2D) -> void:
	print("Collision into an object: ", body.name)
	print("Groups this body belongs to: ", body.get_groups())
	if body.is_in_group("vertical_wall"):
		print("vertical_wall")
		velocity.x = -velocity.x
	if body.is_in_group("upper_wall"):
		print("upper_wall")
		# TODO: Create point system in relation to this for player.

	if body.is_in_group("lower_wall"):
		print("lower_wall")
		# TODO: Create point system in relation to this for enemy.
	if body.is_in_group("paddles"):
		print("paddles")
		# TODO: Create more dynamic responses.
		velocity.y = -velocity.y
		velocity.x = -velocity.x