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

var terrain_cell_coords = Vector2i(1, 0)
var lava_cell_coords = Vector2i(4, 0)

func _ready():
	current_radius = start_radius
	init_map()


func _on_shrink_timer_timeout():
	if current_radius > 0:
		current_radius -= 1
		redraw_map()


func init_map():
	clear()
	
	# Compute center offsets
	var half_width = map_width / 2
	var half_height = map_height / 2
	
	for y in range(map_height):
		for x in range(map_width):
			# Shift coordinates so center is at (0,0)
			var cx = x - half_width
			var cy = y - half_height
			
			if cx*cx + cy*cy > current_radius * current_radius:
				set_cell(Vector2i(cx, cy), 0, lava_cell_coords)
			else:
				set_cell(Vector2i(cx, cy), 0, terrain_cell_coords)


func redraw_map():
	# Compute center offsets
	var half_width = map_width / 2
	var half_height = map_height / 2
	var prev_radius = current_radius + 1
	
	for y in range(map_height):
		for x in range(map_width):
			# Shift coordinates so center is at (0,0)
			var cx = x - half_width
			var cy = y - half_height
			
			var dist_sq = cx*cx + cy*cy
			
			# Only set cells that were in previous radius but not in current radius
			if dist_sq <= prev_radius * prev_radius and dist_sq > current_radius * current_radius:
				set_cell(Vector2i(cx, cy), 0, lava_cell_coords)
