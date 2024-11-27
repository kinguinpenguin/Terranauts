extends TileMap

@onready var player = get_node("/root/World/Player")
@onready var lefttile = get_node("/root/World/LeftTile")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if (player.position.x > self.position.x && player.position.x < self.position.x + 20): # Crossed Centre of Tile
		#player.position.x = lefttile.position.x
