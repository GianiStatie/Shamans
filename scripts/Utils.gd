extends Node


func instantiate_object_in_scene(scene: PackedScene) -> Object:
	var root_scene := get_tree().current_scene
	var object = scene.instantiate()
	root_scene.add_child(object)
	return object
