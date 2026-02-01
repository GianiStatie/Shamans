extends CanvasLayer

@export var button_scene: PackedScene
@onready var current_player_container := $PlayerContainer_0

@onready var player_containers = [
	$PlayerContainer_0, $PlayerContainer_1
]
var button_ref = []


func is_button_on_cooldown(button_idx: int) -> bool:
	if button_idx > len(button_ref) - 1:
		return true
	return button_ref[button_idx].on_cooldown


func press_button(button_idx: int) -> void:
	if button_idx > len(button_ref) - 1:
		return
	button_ref[button_idx]._on_pressed()


func set_player_layout(player_index: int, spell_info: Array) -> void:
	reset()
	current_player_container = player_containers[player_index]
	
	for info in spell_info:
		var button: SpellButton = button_scene.instantiate()
		current_player_container.add_child(button)
		button.update_stats(info.get("cooldown"), info.get("icon"))
		button_ref.append(button)


func reset():
	button_ref = []
	for child in current_player_container.get_children():
		current_player_container.remove_child(child)
		child.queue_free()
