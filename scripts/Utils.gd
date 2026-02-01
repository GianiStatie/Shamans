extends Node

var last_known_angles = {
	"player_0": 0.0,
	"player_1": 0.0
}



func get_cast_angle(player_global_position: Vector2, player_index: int, use_mouse := false) -> float:
	var input_angle = last_known_angles.get("player_%s" % player_index)
	
	if use_mouse:
		var mouse_pos := get_mouse_world_position()
		input_angle = (mouse_pos - player_global_position).angle()
	
	else:
		var input_dir := Vector2(
			Input.get_axis("player_%s_aim_left" % player_index, "player_%s_aim_right" % player_index),
			Input.get_axis("player_%s_aim_up" % player_index, "player_%s_aim_down" % player_index)
		)

		# Deadzone check
		if input_dir.length() > 0.2:
			input_angle = input_dir.angle()
	
	last_known_angles["player_%s" % player_index] = input_angle
	return input_angle


func get_mouse_world_position() -> Vector2:
	var viewport := get_tree().root.get_viewport()
	var camera := viewport.get_camera_2d()

	if camera:
		return camera.get_global_mouse_position()
	
	# Fallback: no camera
	return viewport.get_mouse_position()


func instantiate_object_in_scene(scene: PackedScene, global_position: Vector2) -> Object:
	var root_scene := get_tree().current_scene
	var object = scene.instantiate()
	root_scene.call_deferred("add_child", object)
	object.global_position = global_position
	return object
