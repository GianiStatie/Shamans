extends CanvasLayer

@onready var button_container: MarginContainer = %SpellButton_0
var locations = [
	Control.PRESET_BOTTOM_LEFT,
	Control.PRESET_BOTTOM_RIGHT
]


func set_player_layout(player_index: int) -> void:
	button_container.set_anchors_preset(locations[player_index])
