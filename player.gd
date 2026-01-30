extends CharacterBody2D

enum PLAYER_CONTROLS {
	PLAYER_1,
	PLAYER_2
}

@export var MOVE_MAX_SPEED := 200.0
@export var MOVE_ACCELERATION := 500.0
@export var MOVE_FRICTION := 1000.0
@export var TURN_ACCELERATION = 10.0
@export var PLAYER_CONTROLLER: PLAYER_CONTROLS = 0

@onready var cast_marker = $CastMarker


func _physics_process(delta: float) -> void:
	var cast_angle = (get_global_mouse_position() - global_position).angle()
	var diff = wrapf(cast_angle - cast_marker.rotation, -PI, PI)
	cast_marker.rotation += clamp(
		diff,
		-TURN_ACCELERATION * delta,
		TURN_ACCELERATION * delta
	)
	
	var input_vector := Vector2(
		Input.get_axis("player_left", "player_right"),
		Input.get_axis("player_up", "player_down")
	).normalized()
	
	var target_velocity = input_vector * MOVE_MAX_SPEED

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, MOVE_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
	move_and_slide()
