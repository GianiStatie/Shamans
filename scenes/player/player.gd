class_name Player extends CharacterBody2D

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
@export var spell_1_scene: PackedScene
@export var spell_2_scene: PackedScene
@export var spell_3_scene: PackedScene

@onready var cast_marker = $AttackMarker
@onready var flippable_container = $Flippable
@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var stats = $Stats


var input_vector := Vector2.ZERO
var can_move := true
var dot := 0.0
var dot_delta := 0.0
var dot_interval := 1.0


func _ready() -> void:
	var player_colors = Constants.player_colors["player_%s" % PLAYER_CONTROLLER]
	self.material.set_shader_parameter("to_colors", player_colors)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_%s_spell_0" % PLAYER_CONTROLLER):
		state_machine.transition_to("CastOffensive", {"spell_scene": spell_0_scene})
	elif event.is_action_pressed("player_%s_spell_1" % PLAYER_CONTROLLER):
		state_machine.transition_to("CastDefensive", {"spell_scene": spell_1_scene})
	elif event.is_action_pressed("player_%s_spell_2" % PLAYER_CONTROLLER):
		state_machine.transition_to("CastDefensive", {"spell_scene": spell_2_scene})
	elif event.is_action_pressed("player_%s_spell_3" % PLAYER_CONTROLLER):
		state_machine.transition_to("CastDefensive", {"spell_scene": spell_3_scene})


func _physics_process(delta: float) -> void:
	if can_move:
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
		update_facing_direction()
	else:
		input_vector = Vector2.ZERO
	
	var target_velocity = input_vector * MOVE_MAX_SPEED
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, MOVE_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
	
	move_and_slide()
	
	# apply effects
	dot_delta += delta
	if dot_delta >= dot_interval:
		dot_delta = 0.0
		stats.health -= dot


func cast_spell(spell_scene: PackedScene):
	var spell_position = cast_marker.get_attack_position()
	var spell_angle = cast_marker.get_attack_rotation()
	# we can remove the normalized to put back the bug with the fade-away
	var spell_direction = global_position.direction_to(spell_position).normalized()
	var spell_object = Utils.instantiate_object_in_scene(spell_scene, spell_position)
	spell_object.cast(self, spell_direction, spell_angle)


func update_facing_diection_cast() -> void:
	var spell_position = cast_marker.get_attack_position()
	var spell_direction = global_position.direction_to(spell_position).normalized()
	var facing_direction = sign(spell_direction.x)
	if facing_direction != 0:
		flippable_container.scale.x = facing_direction


func update_facing_direction() -> void:
	var facing_direction = sign(velocity.x)
	if facing_direction != 0:
		flippable_container.scale.x = facing_direction


func set_can_move(value: bool) -> void:
	can_move = value


func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Spell") or area.is_in_group("Explosion"):
		if area.source == self:
			return
		var impact_direction = area.global_position.direction_to(self.global_position)
		velocity += impact_direction * area.KNOCKBACK
		stats.health -= area.DAMAGE
		state_machine.transition_to("Hit")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Lava"):
		dot += 5


func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Lava"):
		dot = max(dot - 5, 0.0)
