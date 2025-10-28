extends Node

var SpriteSheet: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($Deck.Get_Count())
	SpriteSheet = load("res://Resources/Textures.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
