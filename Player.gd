extends CharacterBody2D

@onready var sprite = get_node("/root/World/Player/Sprite2D")
@onready var arm = get_node("/root/World/Player/Sprite2D/arm")
@onready var console = get_node("/root/World/console")
@export var speed = 200
@export var friction = 0.08
@export var acceleration = 0.1
@onready var axis = Vector2.ZERO

func _process(delta):
	#if (Input.is_action_just_pressed("interact")):
		#idk make the console work
	if (Input.is_action_just_pressed("save")): # User called save
		var dir = DirAccess.open("res://")
		var save_file = FileAccess.open("res://saves/savegame.save", FileAccess.WRITE)
		var new_data = save_game()
		var json_string = JSON.stringify(new_data)
		save_file.store_line(json_string)
		print("Game Saved.")
	if (Input.is_action_just_pressed("menu")): # User went to the menu
		get_tree().change_scene_to_file("res://menu.tscn")
		return
	

func save_game():
	var save_dict = {
		"filename": "Save1",
		"player_pos_x": self.position.x,
		"player_pos_y": self.position.y,
		"buildings": []
	}
	return save_dict

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		sprite.flip_h = false
	if Input.is_action_pressed('left'):
		input.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
