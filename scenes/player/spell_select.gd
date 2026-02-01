extends MarginContainer

@export var player_index = 0
@export var button_container: HBoxContainer
@onready var focused_button_idx = 0
@onready var all_spell_scenes = {
	"meteor": preload("res://scenes/spells/meteor.tscn"),
	"boomerang": preload("res://scenes/spells/boomerang.tscn"),
	"smoke": preload("res://scenes/spells/smoke.tscn"),
	"teleport": preload("res://scenes/spells/teleport.tscn"),
	"fireball": preload("res://scenes/spells/fireball.tscn"),
	"anivia_wall": preload("res://scenes/spells/anivia_wall.tscn"),
}

var spell_scene_tempalte_path = "res://scenes/spells/%s.tscn"
var selected_spells_scenes = []
var selected_spells_names = []

signal spells_selected(selected_spell_scenes)


func _ready() -> void:
	for child in button_container.get_children():
		child.pressed.connect(_on_button_pressed.bind(child.name))


func focus_button(new_button_idx) -> void:
	var focused_button = button_container.get_child(focused_button_idx)
	focused_button.release_focus()
	
	var new_button = button_container.get_child(new_button_idx)
	new_button.grab_focus()
	focused_button_idx = new_button_idx


func _on_button_pressed(button_name: String) -> void:
	if len(selected_spells_names) >= 4:
		return
	
	if button_name in selected_spells_names:
		return
	
	selected_spells_scenes.append(all_spell_scenes[button_name])
	selected_spells_names.append(button_name)
	
	for button in button_container.get_children():
		if button.name == button_name:
			button.disabled = true
			break
	
	if len(selected_spells_names) == 4:
		self.visible = false
		spells_selected.emit(selected_spells_scenes)
