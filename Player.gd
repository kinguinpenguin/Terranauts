extends CharacterBody2D

@export var FRICTION = 300
@export var jump_impulse = 350
@export var GRAVITY = 5
@onready var sprite = get_node("/root/World/Player/Sprite2D")
@onready var arm = get_node("/root/World/Player/Sprite2D/arm")
@onready var console = get_node("/root/World/console")

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
	var pos = get_viewport().get_mouse_position()
	var res = get_viewport().get_visible_rect().size
	var posx = pos.x
	var posy = pos.y
	if (posx > res.x):
		posx = res.x
	elif (posx < 0):
		posx = 0
	if (posy > res.y):
		posy = res.y
	elif (posy < 0):
		posy = 0
	if (posx >= res.x/2): # Cursor is to the right of player, so face right
		sprite.flip_h = false
		arm.flip_h = false
		arm.position.x = -abs(arm.position.x)
		arm.rotation = atan((posy - res.y/2 + sprite.texture.get_height()/2)/(posx - res.x/2)) - 3.14/2
	else: # Facing left
		sprite.flip_h = true
		arm.flip_h = true
		arm.position.x = abs(arm.position.x)
		arm.rotation = atan((posy - res.y/2 + sprite.texture.get_height()/2)/(posx - res.x/2)) + 3.14/2
	

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
		velocity.x = 200
	elif (Input.is_action_pressed("move_left")):
		velocity.x = -200
	else:
		apply_friction(FRICTION*delta)
	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity.x -= velocity.normalized().x * amount
	else:
		velocity.x = 0
