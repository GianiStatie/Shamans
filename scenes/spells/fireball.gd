class_name Spell
extends Area2D

const MAX_SPEED: float = 200
const KNOCKBACK: float = 100

var direction := Vector2.ZERO

func cast(cast_global_position: Vector2, cast_direction: Vector2, cast_rotation: float) -> void:
	self.global_position = cast_global_position
	self.direction = cast_direction
	self.rotation = cast_rotation


func _physics_process(delta: float) -> void:
	var velocity = direction * MAX_SPEED
	global_position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
