extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("saves"): # dir doesn't exist
		dir.make_dir("saves")
	var save_file = FileAccess.open("res://saves/newgame.save", FileAccess.WRITE)
	var new_data = new_game()
	var json_string = JSON.stringify(new_data)
	save_file.store_line(json_string)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pressed(): # User started new game
	var new_file = FileAccess.open("res://saves/newgame.save", FileAccess.READ)
	while (new_file.get_position() < new_file.get_length()):
		var json_string = new_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data = json.get_data()
		
		var dir = DirAccess.open("res://saves")
		dir.remove("res://saves/savegame.save")
		var save_file = FileAccess.open("res://saves/savegame.save", FileAccess.WRITE)
		var newdata = JSON.stringify(node_data)
		save_file.store_line(newdata)
	get_tree().change_scene_to_file("res://world.tscn")

func new_game():
	var save_dict = {
		"filename": "Save1",
		"player_pos_x": 0,
		"player_pos_y": 40,
		"buildings": []
	}
	return save_dict
