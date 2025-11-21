extends TileMapLayer


func _process(delta: float) -> void:
	var player = $"../../Character_Minigame"
	
	var tile_pos = tilemap.local_to_map(player.position)
	var above_tile = tilemap.get_cell_tile_data(tile_pos)

	if above_tile and above_tile.get_custom_data("is_tall"):
		if player.global_position.y > tilemap.map_to_local(tile_pos).y:
			# Player is behind → fade/hide this tile
			tilemap.set_cell(tile_pos, source_id, atlas_coords, 0, tile_data_id) # or change modulate
		else:
			pass
			# Player is in front → show fully
