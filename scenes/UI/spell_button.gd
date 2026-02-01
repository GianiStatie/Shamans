extends TextureButton

var ON_COOLDOWN = false
var COOLDOWN_TIME = 1.0
var cooldown_delta = 0.0

@onready var cooldown_indicator = $Cover


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
	self.disabled = false
	ON_COOLDOWN = false
	cooldown_delta = 0.0
	cooldown_indicator.value = 0.0


func _on_pressed() -> void:
	disabled = true
	ON_COOLDOWN = true
	
