extends Node

@export var health := 100.0 : set = _on_health_changed
@onready var health_bar = $HealthBar


func _ready() -> void:
	health_bar.value = health

func _on_health_changed(value: float) -> void:
	health = value
	health_bar.value = value
