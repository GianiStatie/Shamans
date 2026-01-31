class_name Spell
extends Area2D

@export var MAX_SPEED: float = 300.0
@export var KNOCKBACK: float = 100.0
@export var veocity_curve: Curve

@onready var timer: Timer = $Timer



var direction := Vector2.ZERO

func cast(cast_global_position: Vector2, cast_direction: Vector2, cast_rotation: float) -> void:
	self.global_position = cast_global_position
	self.direction = cast_direction
	self.rotation = cast_rotation


func _physics_process(delta: float) -> void:
	var sample_time = 1 - timer.time_left / timer.wait_time
	var velocity = direction * MAX_SPEED * veocity_curve.sample(sample_time)
	global_position += velocity * delta
	
	var sprite_scale = min(sample_time * 5, 1.0)
	scale = Vector2(sprite_scale, sprite_scale)


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
