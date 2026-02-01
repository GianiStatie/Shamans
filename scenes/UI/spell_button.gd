class_name SpellButton extends MarginContainer

var ON_COOLDOWN = false
var COOLDOWN_TIME = 1.0
var cooldown_delta = 0.0

@export var cooldown_indicator: TextureProgressBar


func _ready() -> void:
	reset()


func _physics_process(delta: float) -> void:
	if not ON_COOLDOWN:
		return
	
	cooldown_delta += delta
	var cooldown_perc = cooldown_delta / COOLDOWN_TIME
	cooldown_indicator.value = cooldown_perc
	
	if cooldown_perc >= 1.0:
		reset()


func reset() -> void:
	ON_COOLDOWN = false
	cooldown_delta = 0.0
	cooldown_indicator.value = 0.0


func _on_pressed() -> void:
	ON_COOLDOWN = true
