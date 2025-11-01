# The deck essentially "holds" all cards, and will be removed when 

extends Node

var CardsInHand: int = 0
var HandValue: int = 0
var HandNumber: int
	
func Reset_Hand() -> void:
	CardsInHand = 0
	HandValue = 0
	
	var children = get_children()
	for child in children:
		child.queue_free()
		
func Get_Card(NewCard: card) -> void:
	self.add_child(NewCard)
	HandValue += NewCard.value
	CardsInHand += 1

func Get_Card_Count() -> int:
	return CardsInHand
	
func Get_Value() -> int:
	return HandValue
