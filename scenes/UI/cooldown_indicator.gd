extends TextureRect

@export var frames: SpriteFrames
var value = 0.0 : set = _on_value_changed


func _on_value_changed(new_value: float) -> void:
	value = clampf(new_value, 0.0, 1.0)
	var frame_idx = int(value * 100)
	self.texture = frames.get_frame_texture("default", frame_idx)
	self.visible = value != 0.0
