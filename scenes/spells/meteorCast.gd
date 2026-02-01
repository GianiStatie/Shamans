extends Spell

var direction := Vector2.ZERO


func cast(cast_source: Player, cast_direction: Vector2, cast_rotation: float) -> void:
	self.source = cast_source
	self.direction = cast_direction
	self.rotation = cast_rotation


func _physics_process(delta: float) -> void:
	var sample_time = 1.0 - timer.time_left / timer.wait_time
	sample_time = clamp(sample_time, 0.0, 1.0)

	var speed = MAX_SPEED * velocity_curve.sample(sample_time)
	var velocity = direction * speed
	global_position += velocity * delta

	var sprite_scale = min(sample_time * 5.0, 1.0)
	scale = Vector2(sprite_scale, sprite_scale)


func _on_timer_timeout() -> void:
	var effect = Utils.instantiate_object_in_scene(on_hit_effect, global_position)
	effect.source = source
	queue_free()
