extends Marker2D

@export var offset = Vector2(360, 0)
@onready var sprite = $Sprite

func _ready() -> void:
	sprite.offset = offset
