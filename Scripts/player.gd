extends Node

var stand: bool = false
var broke: bool = false
	
func reset() -> void:
	$Hand.Reset_Hand()
	self.stand = false
	self.broke = false

func Get_Stand() -> bool:
	return stand
	
func Set_Stand(state: bool) -> void:
	self.stand = state
	
func Get_Broke() -> bool:
	return broke
	
func Set_Broke(state: bool) -> void:
	self.broke = state
