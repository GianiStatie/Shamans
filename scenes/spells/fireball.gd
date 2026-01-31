class_name Spell
extends Area2D

@export var MAX_SPEED: float = 300.0
@export var KNOCKBACK: float = 0.0
@export var veocity_curve: Curve

@onready var timer: Timer = $Timer
@onready var explosion_effect = preload("res://scenes/effects/explosion_effect.tscn")


var direction := Vector2.ZERO

func cast(cast_global_position: Vector2, cast_direction: Vector2, cast_rotation: float) -> void:
	self.direction = cast_direction
	self.rotation = cast_rotation


func _physics_process(delta: float) -> void:
	var sample_time = 1 - timer.time_left / timer.wait_time
	var velocity = direction * MAX_SPEED * veocity_curve.sample(sample_time)
	global_position += velocity * delta
	
	var sprite_scale = min(sample_time * 5, 1.0)
	scale = Vector2(sprite_scale, sprite_scale)


func _on_timer_timeout() -> void:
	Utils.instantiate_object_in_scene(explosion_effect, global_position)
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	Utils.instantiate_object_in_scene(explosion_effect, global_position)
	queue_free()
