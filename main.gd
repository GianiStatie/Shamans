extends Node2D

@onready var player_container = $PlayerContainer
@onready var camera = $Camera2D

var safe_camera_margin: Vector2
var initial_zoom: Vector2
var players_ready_cnt: int = 0


func _ready() -> void:
	safe_camera_margin = (get_viewport_rect().size / 2) * 0.7
	initial_zoom = camera.zoom


func _physics_process(_delta: float) -> void:
	var min_pos = Vector2.INF
	var max_pos = -Vector2.INF
	for child in player_container.get_children():
		min_pos.x = min(min_pos.x, child.global_position.x)
		max_pos.x = max(max_pos.x, child.global_position.x)
		min_pos.y = min(min_pos.y, child.global_position.y)
		max_pos.y = max(max_pos.y, child.global_position.y)
	
	var player_distance = max_pos - min_pos
	var center_point = min_pos + player_distance / 2
	camera.global_position = camera.global_position.lerp(center_point, 0.1)
	
	var ratio = safe_camera_margin / player_distance
	var zoom_factor = min(ratio.x, ratio.y)
	if zoom_factor < 1.0 and zoom_factor >= 0.5:
		camera.zoom = camera.zoom.lerp(initial_zoom * zoom_factor, 0.5)


func _on_player_spells_are_ready() -> void:
	players_ready_cnt += 1
	if players_ready_cnt != player_container.get_child_count():
		return
	for child in player_container.get_children():
		child.is_ready = true
