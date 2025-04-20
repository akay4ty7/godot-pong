extends CharacterBody2D

# Adjust this to control difficulty (lower = easier)
const MAX_SPEED = 150.0

var ball = Node2D

func _ready():
    ball = get_node("../Ball")

func _physics_process(delta: float) -> void:
    if !ball:
        return
    
    # Simply track the ball's X position directly
    var target_x = ball.position.x
    
    # Calculate direction to move
    var direction = target_x - position.x
    
    # Set velocity with speed limit (this makes it beatable)
    velocity.x = clamp(direction * 10.0, -MAX_SPEED, MAX_SPEED)
    
    # Apply movement
    move_and_slide()