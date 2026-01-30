extends Marker2D

@export var offset = Vector2(360, 0)
@onready var sprite = $Sprite


func _ready() -> void:
	sprite.offset = offset


func get_attack_position() -> Vector2:
	return sprite.global_position + sprite.global_transform.basis_xform(sprite.offset)


func get_attack_rotation() -> float:
	return self.rotation
