extends Node

signal player_action(action: String)

var stand: bool = false
var broke: bool = false

# Sets all buttons to hidden on creation
func _ready() -> void:
	Set_Turn_Visible(false)
	Set_Ace_Visible(false)
	
func reset() -> void:
	$Hand.Reset_Hand()
	self.stand = false
	self.broke = false
	Set_Turn_Visible(false)
	Set_Ace_Visible(false)

func Get_Stand() -> bool:
	return stand
	
func Set_Stand(state: bool) -> void:
	self.stand = state
	
func Get_Broke() -> bool:
	return broke
	
func Set_Broke(state: bool) -> void:
	self.broke = state

func Set_Turn_Visible(state: bool) -> void:
	$Hit.visible = state
	$Stand.visible = state
	
func Set_Ace_Visible(state: bool) -> void:
	$Ace1.visible = state
	$Ace11.visible = state

func _on_hit_pressed() -> void:
	emit_signal("player_action", "hit")

func _on_stand_pressed() -> void:
	emit_signal("player_action", "stand")

func _on_ace_1_pressed() -> void:
	emit_signal("player_action", "1")

func _on_ace_11_pressed() -> void:
	emit_signal("player_action", "11")
