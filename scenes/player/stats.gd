extends Node

@export var max_health := 100.0
@onready var health_bar = $HealthBar
var health = max_health : set = _on_health_changed
signal player_health_zero

func _ready() -> void:
	health_bar.value = max_health

func _on_health_changed(value: float) -> void:
	health = value
	health_bar.value = value
	if (health <= 0):
		player_health_zero.emit()
