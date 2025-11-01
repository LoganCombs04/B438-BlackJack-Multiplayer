extends Node

signal player_action(action: String)

var stand: bool = false
var broke: bool = false

func Get_Stand() -> bool:
	return self.stand
	
func Set_Stand(state: bool) -> void:
	self.stand = state
	
func Get_Broke() -> bool:
	return self.broke

func Set_Broke(state: bool) -> void:
	self.broke = state
