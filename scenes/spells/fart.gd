extends Spell

var source: Player


func cast(cast_source: Player, _cast_direction: Vector2, _cast_rotation: float) -> void:
	self.source = cast_source
	self.global_position = cast_source.global_position


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
