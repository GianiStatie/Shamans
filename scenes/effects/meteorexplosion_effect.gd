class_name MeteorExplosion extends Area2D

@export var KNOCKBACK: float = 100.0
@export var DAMAGE: float = 0.0
var source: Player # TODO: we can add player here so he's not affected


func _on_explosion_effect_animation_finished() -> void:
	print("dgdgh")
	queue_free()
