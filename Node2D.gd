extends Node
tool

export (Texture) var image setget set_image

export (Vector2) var tile_size setget set_tile_size#, get_tile_size

export (Vector2) var shape_extents setget set_shape_extents, get_shape_extents

export (bool) var create_shapes = false
export (bool) var create_light_occluder = false
#export (int, "Area2d", "StaticBody2d", "KinematicBody2d", "RigidBody2d") var collision_type setget set_collision_type, get_collision_type

func set_shape_extents(value):
	shape_extents = value
	_update()
func get_shape_extents():
	return shape_extents

func set_image(value):
	image = value
	_update()
	
func set_tile_size(value):
	tile_size = value
	_update()
	
func get_tile_size():
	return tile_size
	
func _clear():
	for child in get_children():
		remove_child(child)

func _update():
	_clear()
	
	if image == null || tile_size == null || shape_extents == null:
		return
	
	var tiles_size = Vector2(image.get_size() / tile_size)
	
	var count = 0
	for y in range(tiles_size.y):
		for x in range(tiles_size.x):
			
			var sb2d = StaticBody2D.new()
			var rect_shape = RectangleShape2D.new()
			var col_shape = CollisionShape2D.new()
			if create_shapes:
				rect_shape.set_extents(shape_extents)
				col_shape.set_shape(rect_shape)
			
				sb2d.add_child(col_shape)
			
			var sprite = Sprite.new()
			add_child(sprite)
			sprite.set_owner(self)
			if create_shapes:
				sprite.add_child(sb2d)
			sb2d.add_to_group("Floor", true)
			sb2d.add_to_group("Wall", true)
			sb2d.set_owner(self)
			col_shape.set_owner(self)
			

			#sb2d.set_name("Tile"+String(count).pad_zeros(3))
			
			
			
			sprite.set_name("Sprite"+String(count).pad_zeros(3))
			sprite.set_texture(image)
			sprite.set_region(true)
			var rect = Rect2(
				x * int(tile_size.x),
				y * int(tile_size.y),
				tile_size.x,
				tile_size.y
			)
			sprite.set_region_rect(rect)
			
			var light_occluder = LightOccluder2D.new()
			var occluder_shape = OccluderPolygon2D.new()
			light_occluder.add_child(occluder_shape)
			
			occluder_shape.set_polygon(PoolVector2Array([
				Vector2(shape_extents.x,-shape_extents.y),
				Vector2(-shape_extents.x,-shape_extents.y),
				Vector2(-shape_extents.x,shape_extents.y),
				Vector2(shape_extents.x,shape_extents.y)
			]))
			
			light_occluder.set_occluder_polygon(occluder_shape)
			
			if create_light_occluder:
				sprite.add_child(light_occluder)
				light_occluder.set_owner(self)
				#occluder_shape.set_owner(self)
				pass
			
			count += 1



