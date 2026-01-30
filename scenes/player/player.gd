extends CharacterBody2D

enum PLAYERS {
	PLAYER_1,
	PLAYER_2
}

# PLAYER STATS
@export var MOVE_MAX_SPEED := 200.0 * 0.69
@export var MOVE_ACCELERATION := 500.0 * 0.69
@export var MOVE_FRICTION := 1000.0 * 0.69
@export var TURN_ACCELERATION = 10.0 
@export var PLAYER_CONTROLLER: PLAYERS = PLAYERS.PLAYER_1

# PLAYER SPELLS
@export var spell_0_scene: PackedScene

@onready var cast_marker = $AttackMarker
@onready var flippable_container = $Flippable
@onready var animation_player = $AnimationPlayer


var input_vector = Vector2.ZERO


func _ready() -> void:
	# TODO: change collision layer based on player index
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_%s_spell_0" % PLAYER_CONTROLLER):
		var spell_position = cast_marker.get_attack_position()
		var spell_angle = cast_marker.get_attack_rotation()
		var spell_direction = global_position.direction_to(spell_position)
		var object = Utils.instantiate_object_in_scene(spell_0_scene)
		object.cast(spell_position, spell_direction, spell_angle)
		print("cast_0")
	elif event.is_action_pressed("player_%s_spell_1" % PLAYER_CONTROLLER):
		print("cast_1")


func _physics_process(delta: float) -> void:
	var cast_angle = (get_global_mouse_position() - global_position).angle()
	var diff = wrapf(cast_angle - cast_marker.rotation, -PI, PI)
	cast_marker.rotation += clamp(
		diff,
		-TURN_ACCELERATION * delta,
		TURN_ACCELERATION * delta
	)
	
	input_vector = Vector2(
		Input.get_axis("player_%s_left" % PLAYER_CONTROLLER, "player_%s_right" % PLAYER_CONTROLLER),
		Input.get_axis("player_%s_up" % PLAYER_CONTROLLER, "player_%s_down" % PLAYER_CONTROLLER)
	).normalized()
	
	var target_velocity = input_vector * MOVE_MAX_SPEED
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, MOVE_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
	
	if velocity == Vector2.ZERO:
		animation_player.play("Idle")
	else:
		animation_player.play("Move")
	
	update_facing_direction()
	move_and_slide()


func update_facing_direction() -> void:
	var facing_direction = sign(input_vector.x)
	if facing_direction != 0:
		flippable_container.scale.x = facing_direction


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Spell"):
		var impact_direction = area.global_position.direction_to(self.global_position)
