extends Node


func instantiate_object_in_scene(scene: PackedScene, global_position: Vector2) -> Object:
	var root_scene := get_tree().current_scene
	var object = scene.instantiate()
	root_scene.add_child(object)
	object.global_position = global_position
	return object
