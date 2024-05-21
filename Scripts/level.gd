extends Node2D

class_name Level

const BALL: PackedScene = preload("res://Scenes/ball.tscn")

signal on_game_restart

var ball: Ball
@export var score: int = 0
@export var lives: int = 3
@onready var player: Paddle = $Player
@onready var score_label = %Score
@onready var lives_label = %Lives
@onready var restart = %Restart
@onready var game_over_screen = %GameOverScreen
var curr_lives: int

func _ready() -> void:
	curr_lives = lives
	game_over_screen.visible = false
	score_label.text = "Score: 0"
	lives_label.text = "Lives: " + str(lives)

	
	start_ball()

func update_score(increase: int) -> void:
	score += increase
	score_label.text = "Score: " + str(score)

func start_ball() -> void:
	ball = BALL.instantiate()
	ball.reset()
	ball._initial_speed = 300
	ball.position = player.ballSpawnLocation.position
	ball.score_up.connect(update_score)
	player.add_child(ball)
	player.release_ball.connect(_on_paddle_release_ball)

func game_over() -> void:
	restart.pressed.connect(restart_game)
	game_over_screen.visible = true

func restart_game() -> void:
	if restart.pressed.is_connected(restart_game):
		restart.pressed.disconnect(restart_game)
	curr_lives = lives
	score = 0
	score_label.text = "Score: 0"
	lives_label.text = "Lives: " + str(lives)
	on_game_restart.emit()
	
	game_over_screen.visible = false
	start_ball()

func _on_paddle_release_ball() -> void:
	ball.reparent(get_node("."))
	ball.play()
	if player.release_ball.is_connected(_on_paddle_release_ball):
		player.release_ball.disconnect(_on_paddle_release_ball)

func _on_death_zone_body_entered(body) -> void:
	if body is Ball:
		body.queue_free()
		curr_lives -= 1
		lives_label.text = "Lives: " + str(curr_lives)
		if curr_lives == 0:
			game_over()
			return
		call_deferred("start_ball")
