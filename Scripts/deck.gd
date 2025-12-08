# The deck essentially "holds" all cards, and will be removed when 

extends Node

var rng = RandomNumberGenerator.new() # RNG generator for selecting an item from the deck.
var CardsLeft: int = 0
const CardScene: PackedScene = preload("res://Scenes/card.tscn")

func reset() -> void:
	CardsLeft = 0
	var children = get_children()
	for child in children:
		child.queue_free()
	
func Reset_Deck(decks: int) -> void: # Creates a new Deck, and erases all cards previously in the deck.
	CardsLeft = 0
	var children = get_children()
	for child in children:
		child.queue_free()
		
	print(CardsLeft) # DEBUG REMOVE LATER
	print(get_children()) # DEBUG REMOVE LATER
	for a in range(decks): # Loops for amount of decks selected.
		for i in 4:
			for j in 14:
				var newcard = CardScene.instantiate()
				newcard.suite = i
				newcard.face = j
				newcard.visible = false
				newcard.value = -1
				if(newcard.face <= 9): # Sets a card's face value to their actual value.
					newcard.value = (newcard.face + 1)
				elif((newcard.face == 10) or (newcard.face == 11) or (newcard.face == 12)): # Sets Jack, Queen, and King value to 10.
					newcard.value = 10 
				else:
					newcard.value = -1 # This is a placeholder for an Ace. This will be chosen by the player in the game's script.
				
				self.add_child(newcard)
				CardsLeft += 1
			
	print(CardsLeft) # DEBUG REMOVE LATER
	print(get_children()) # DEBUG REMOVE LATER

func Get_Count() -> int:
	return CardsLeft
	
func Give_Random_Card() -> Array:
	if(CardsLeft != 0):
		var chosencard = get_child(rng.randi_range(0, (CardsLeft - 1)))
		var chosensuite = chosencard.Get_Suite()
		var chosenface = chosencard.Get_Face()
		var chosenvalue = chosencard.Get_Value()
		
		remove_child(chosencard)
		CardsLeft -= 1
		return [chosensuite, chosenface, chosenvalue]
		
	else:
		print("ERROR: PLEASE THROW STOP GAME")
		return [0, 0, -50]
