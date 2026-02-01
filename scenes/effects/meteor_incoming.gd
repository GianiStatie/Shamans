extends Area2D

@export var Meteor: PackedScene
var source: Player


func _on_timer_timeout() -> void:
	var effect = Utils.instantiate_object_in_scene(Meteor, global_position)
	effect.source = source
	queue_free()
