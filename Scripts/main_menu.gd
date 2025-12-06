extends Node

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	View_Main_Menu()

func _on_start_game_pressed() -> void:
	Set_All_Hidden()
	emit_signal("start_game")
	
func Set_All_Hidden() -> void:
	var children = self.get_children()
	for child in children:
		child.visible = false
		
func View_In_Lobby():
	$CreateLobby.hide()
	$JoinLobby.hide()
	$IP.hide()
	$StartGame.show()
	$Back.show()
	
func View_Main_Menu():
	$CreateLobby.show()
	$JoinLobby.show()
	$IP.show()
	$StartGame.hide()
	$Back.hide()

func _on_create_lobby_pressed() -> void:
	View_In_Lobby()

func _on_join_lobby_pressed() -> void:
	View_In_Lobby()

func _on_back_pressed() -> void:
	View_Main_Menu()
