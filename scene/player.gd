extends CharacterBody2D

var direction = Vector2.ZERO
const SPEED = 30.0

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("left"):
		velocity.x -= 1 * SPEED
	if Input.is_action_pressed("right"):
		velocity.x += 1 * SPEED

	direction = velocity * delta
	move_and_slide()