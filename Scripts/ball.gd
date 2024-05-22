extends CharacterBody2D

class_name Ball

signal score_up(int)

@export var _initial_speed: float = 200;

const NEXT_SPRITE: String = "NextSprite"
const SCORE: String = "Score"

var direction: Vector2 = Vector2.DOWN
var speed: float = 200.0

func _physics_process(delta: float):
	velocity = direction * speed * delta
	var collision: KinematicCollision2D = move_and_collide(velocity)
	if not collision:
		return
		
	var tile_map = collision.get_collider() as TileMap
	if tile_map:
		var location = tile_map.get_coords_for_body_rid(collision.get_collider_rid())
		var tile: TileData = tile_map.get_cell_tile_data(0, location)
		if not tile:
			return
		var next_sprite: Vector2i = tile.get_custom_data(NEXT_SPRITE)
		if next_sprite == Vector2i.ZERO:
			tile_map.erase_cell(0, location)
			score_up.emit(tile.get_custom_data(SCORE))
		else:
			var source = tile_map.get_cell_source_id(0, location)
			tile_map.set_cell(0, location, source, next_sprite)
			
	var paddle = collision.get_collider() as Paddle
	if paddle:
		var paddle_local: Vector2 = paddle.to_local(collision.get_position())
		direction = (paddle_local + (paddle_local.length() * Vector2.UP)).normalized()
		return
		
	direction = direction.bounce(collision.get_normal())

func reset() -> void:
	direction = Vector2.DOWN
	speed = 0

func play() -> void:
	speed = _initial_speed

