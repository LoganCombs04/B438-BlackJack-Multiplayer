extends Node

const DeckScene: PackedScene = preload("res://Scenes/deck.tscn")
const SpriteSheet: Texture2D = preload("res://Resources/Textures.png")
var DeckNumber: int = 1

# Creates dependent scenes.
func _ready() -> void: # Create
	var NewDeck = DeckScene.instantiate()
	NewDeck.name = "Deck"
	self.add_child(NewDeck)
