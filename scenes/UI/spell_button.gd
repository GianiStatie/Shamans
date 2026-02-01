class_name SpellButton extends MarginContainer

var COOLDOWN = 1.0
var ICON = null

var cooldown_delta = 0.0
var on_cooldown = false
var is_ready = false

@export var cooldown_indicator: TextureProgressBar
@export var texture_rect: TextureRect


func _ready() -> void:
	update_stats(COOLDOWN, ICON)
	reset()
	is_ready = true


func _physics_process(delta: float) -> void:
	if not on_cooldown:
		return
	
	cooldown_delta += delta
	var cooldown_perc = cooldown_delta / COOLDOWN
	cooldown_indicator.value = cooldown_perc
	
	if cooldown_perc >= 1.0:
		reset()


func reset() -> void:
	on_cooldown = false
	cooldown_delta = 0.0
	cooldown_indicator.value = 0.0


func _on_pressed() -> void:
	on_cooldown = true


func update_stats(cooldown, icon) -> void:
	ICON = icon
	COOLDOWN = cooldown
	
	if is_ready:
		texture_rect.texture = ICON
