class_name Spell extends Area2D

@export var MAX_SPEED: float = 0.0
@export var KNOCKBACK: float = 0.0
@export var DAMAGE: float = 0.0
@export var on_hit_effect: PackedScene
@export var velocity_curve: Curve

@onready var timer: Timer = $Timer


func cast(_cast_source: Player, _cast_direction: Vector2, _cast_rotation: float) -> void:
	pass
