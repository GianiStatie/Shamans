extends Area2D

@export var KNOCKBACK: float = 100.0


func _on_explosion_effect_animation_finished() -> void:
	queue_free()
