extends CharacterBody2D

enum PLAYERS {
	PLAYER_1,
	PLAYER_2
}

# PLAYER STATS
@export var MOVE_MAX_SPEED := 140.0
@export var MOVE_ACCELERATION := 345.0
@export var MOVE_FRICTION := 690.0
@export var TURN_ACCELERATION = 7.0 
@export var PLAYER_CONTROLLER: PLAYERS = PLAYERS.PLAYER_1

# PLAYER SPELLS
@export var spell_0_scene: PackedScene

@onready var cast_marker = $AttackMarker
@onready var flippable_container = $Flippable
@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer


var input_vector := Vector2.ZERO
var can_move := true


func _ready() -> void:
	# TODO: change collision layer based on player index
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_%s_spell_0" % PLAYER_CONTROLLER):
		print("here")
		state_machine.transition_to("CastOffensive", {"spell_scene": spell_0_scene})
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
	
	if can_move:
		input_vector = Vector2(
			Input.get_axis("player_%s_left" % PLAYER_CONTROLLER, "player_%s_right" % PLAYER_CONTROLLER),
			Input.get_axis("player_%s_up" % PLAYER_CONTROLLER, "player_%s_down" % PLAYER_CONTROLLER)
		).normalized()
		update_facing_direction()
	else:
		input_vector = Vector2.ZERO
	
	var target_velocity = input_vector * MOVE_MAX_SPEED
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, MOVE_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
	
	move_and_slide()


func cast_spell(spell_scene: PackedScene):
	var spell_position = cast_marker.get_attack_position()
	var spell_angle = cast_marker.get_attack_rotation()
	var spell_direction = global_position.direction_to(spell_position)
	var object = Utils.instantiate_object_in_scene(spell_scene)
	object.cast(spell_position, spell_direction, spell_angle)
	update_facing_direction(sign(spell_direction.x))


func update_facing_direction(facing_direction = 0) -> void:
	if facing_direction == 0:
		facing_direction = sign(velocity.x)
	
	if facing_direction != 0:
		flippable_container.scale.x = facing_direction


func set_can_move(value: bool) -> void:
	can_move = value


func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Spell"):
		var impact_direction = area.global_position.direction_to(self.global_position)
