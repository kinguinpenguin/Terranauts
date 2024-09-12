extends CharacterBody2D

@export var FRICTION = 300
@export var jump_impulse = 350
@export var GRAVITY = 5
@onready var sprite = get_node("/root/World/Player/Sprite2D")
@onready var arm = get_node("/root/World/Player/Sprite2D/arm")

@onready var axis = Vector2.ZERO

func _process(delta):
	if (Input.is_action_just_pressed("save")): # User called save
		var dir = DirAccess.open("res://")
		var save_file = FileAccess.open("res://saves/savegame.save", FileAccess.WRITE)
		var new_data = save_game()
		var json_string = JSON.stringify(new_data)
		save_file.store_line(json_string)
		print("Game Saved.")
	if (Input.is_action_just_pressed("menu")): # User went to the menu
		get_tree().change_scene_to_file("res://menu.tscn")
		

func save_game():
	var save_dict = {
		"filename": "Save1",
		"player_pos_x": self.position.x,
		"player_pos_y": self.position.y,
		"buildings": []
	}
	return save_dict

func _physics_process(delta):
	velocity.y += GRAVITY
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_impulse
	if (Input.is_action_pressed("move_right")):
		sprite.flip_h = false
		arm.flip_h = false
		arm.position.x = -abs(arm.position.x)
		velocity.x = 200
	elif (Input.is_action_pressed("move_left")):
		velocity.x = -200
		sprite.flip_h = true
		arm.flip_h = true
		arm.position.x = abs(arm.position.x)
	else:
		apply_friction(FRICTION*delta)
	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity.x -= velocity.normalized().x * amount
	else:
		velocity.x = 0
