extends TileMapLayer

# Map size
@export var map_width: int = 300
@export var map_height: int = 300

# Square margin from edge
@export var square_margin: int = 1

# Circle parameters
@export var start_radius: int = 50
var current_radius: int
var shrink_timer: Timer

var terrain_cell_info = [0, Vector2i(1, 0)]
var edge_cell_info = [0, Vector2i(5, 0)]
var lava_cell_info = [1, Vector2i(4, 0)]

func _ready():
	current_radius = start_radius
	init_map()


func _on_shrink_timer_timeout():
	if current_radius > 0:
		current_radius -= 1
		redraw_map()


func init_map():
	clear()
	
	var half_width = map_width / 2
	var half_height = map_height / 2
	var r2 = current_radius * current_radius
	var edge_thickness = 1  # tiles

	for y in range(map_height):
		for x in range(map_width):
			var cx = x - half_width
			var cy = y - half_height
			var dist_sq = cx*cx + cy*cy
			
			if dist_sq < r2:
				set_cell(Vector2i(cx, cy), terrain_cell_info[0], terrain_cell_info[1])
			elif dist_sq > (current_radius - edge_thickness) * (current_radius - edge_thickness):
				set_cell(Vector2i(cx, cy), lava_cell_info[0], lava_cell_info[1])


func redraw_map():
	var half_width = map_width / 2
	var half_height = map_height / 2

	var r = current_radius
	var prev_r = current_radius + 2

	var r2 = r * r
	var edge_r2 = (r + 1) * (r + 1)
	var prev_r2 = prev_r * prev_r

	for y in range(map_height):
		for x in range(map_width):
			var cx = x - half_width
			var cy = y - half_height
			var dist_sq = cx*cx + cy*cy

			# Only affect the removed ring
			if dist_sq > r2 and dist_sq <= prev_r2:
				if dist_sq <= edge_r2:
					set_cell(Vector2i(cx, cy), edge_cell_info[0], edge_cell_info[1])
				else:
					set_cell(Vector2i(cx, cy), lava_cell_info[0], lava_cell_info[1])
