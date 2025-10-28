# The deck essentially "holds" all cards, and will be removed when 

extends Node

var rng = RandomNumberGenerator.new() # RNG generator for selecting an item from the deck.
var CardsLeft: int = 0
var DeckNumber: int = 1
const CardScene: PackedScene = preload("res://Scenes/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (get_tree().get_root().has_node("Main")): # Checks to see if the Main scene is loaded, and pulls the deck number selected by the player.
		DeckNumber = get_tree().get_root().get_node("Main").DeckNumber
	Reset_Deck(DeckNumber)
	
func Reset_Deck(decks: int) -> void: # Creates a new Deck, and erases all cards previously in the deck.
	CardsLeft = 0
	var children = get_children()
	for child in children:
		child.queue_free()
		
	print(CardsLeft) # DEBUG REMOVE LATER
	print(get_children()) # DEBUG REMOVE LATER
	for a in range(DeckNumber): # Loops for amount of decks selected.
		for i in 4:
			for j in 13:
				var newcard = CardScene.instantiate()
				newcard.suite = i
				newcard.face = j
				newcard.visible = false
				self.add_child(newcard)
				CardsLeft += 1
			
	print(CardsLeft) # DEBUG REMOVE LATER
	print(get_children()) # DEBUG REMOVE LATER

func Get_Count() -> int:
	return CardsLeft
	
func Get_Random_Card() -> card:
	var chosencard = get_child(rng.randi_range(0, (CardsLeft - 1)))
	remove_child(chosencard.name)
	return chosencard
