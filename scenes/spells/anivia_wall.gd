class_name AniviaWall
extends Spell


func cast(cast_source: Player, cast_direction: Vector2, cast_rotation: float) -> void:
	self.source = null


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
