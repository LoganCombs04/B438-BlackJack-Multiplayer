extends Node

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_start_game_pressed() -> void:
	Set_Visibility(false)
	emit_signal("start_game")
	
func Set_Visibility(state: bool) -> void:
	var children = self.get_children()
	for child in children:
		child.visible = state
