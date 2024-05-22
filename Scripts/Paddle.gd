extends CharacterBody2D

class_name Paddle

const SPEED = 300.0

@onready var ballSpawnLocation: Marker2D = $BallSpawnLocation
signal release_ball

func _ready() -> void:
	pass

func _physics_process(_delta) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	move_and_slide()
		

func _input(event) -> void:
	if event.is_action_pressed("release"):
		release_ball.emit()
