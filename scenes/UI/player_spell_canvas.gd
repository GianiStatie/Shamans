extends CanvasLayer

@export var button_scene: PackedScene
@onready var current_player_container: MarginContainer = $PlayerContainer_0

@onready var player_containers = [
	$PlayerContainer_0, $PlayerContainer_1
]


func set_player_layout(player_index: int, spell_info: Array) -> void:
	current_player_container = player_containers[player_index]
	
	var button_ref = []
	for info in spell_info:
		var button: SpellButton = button_scene.instantiate()
		current_player_container.add_child(button)
		button.update_stats(info.get("cooldown"), info.get("icon"))
