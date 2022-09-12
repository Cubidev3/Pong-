extends Polygon2D

var crate_fab = preload("res://Actors/Crate.tscn")
var blocks_array: Array = []
export var crate_width = 32
export var crates_number = 16
export var world_blocks: Array = []
var tryies = 100

func crate_polygon(pos: Vector2, width: float) -> PoolVector2Array:
	var pol = PoolVector2Array([pos, pos + Vector2(0, width), pos + Vector2(width, width), pos + Vector2(width, 0)])
	return pol

func random_position_on_area(area: Polygon2D) -> Vector2:
	var start_point = area.polygon[0] + global_position
	var ending_point = area.polygon[2] + global_position
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_position = Vector2(rng.randf_range(start_point.x, ending_point.x - crate_width), rng.randf_range(start_point.y, ending_point.y - crate_width))
	return new_position
	
func _is_colliding_with_blocks(crate: PoolVector2Array) -> bool:
	if blocks_array.size() == 0: return false
	for i in blocks_array.size():
		if !Geometry.intersect_polygons_2d(crate, blocks_array[i]).empty():
			print(crate, " : ", blocks_array[i])
			return true
	return false
	
func _ready():
	blocks_array.append_array(world_blocks)
	
	while crates_number > 0 and tryies > 0:
		var new_pos = random_position_on_area(self)
		var new_crate_pol = crate_polygon(new_pos, crate_width)
		if not _is_colliding_with_blocks(new_crate_pol):
			blocks_array.append(new_crate_pol)
			var real_crate = crate_fab.instance()._build(new_pos)
			get_parent().call_deferred("add_child", real_crate)
			crates_number -= 1
			tryies = 100
		else:
			tryies -= 1
			
