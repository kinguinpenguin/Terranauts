extends Node2D

@onready var player = get_node("/root/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("test")
	if not FileAccess.file_exists("res://saves/savegame.save"):
		get_tree().change_scene_to_file("res://menu.tscn")
	else:
		var save_file = FileAccess.open("res://saves/savegame.save", FileAccess.READ)
		while (save_file.get_position() < save_file.get_length()):
			var json_string = save_file.get_line()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
			var node_data = json.get_data()
			player.position.x = node_data["player_pos_x"]
			player.position.y = node_data["player_pos_y"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
