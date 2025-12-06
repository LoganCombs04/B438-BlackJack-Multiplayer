extends Node

const DeckScene: PackedScene = preload("res://Scenes/deck.tscn")
const Player: PackedScene = preload("res://Scenes/player.tscn")
const SpriteSheet: Texture2D = preload("res://Resources/Textures.png")

var DeckNumber: int = 1
var GameActive: bool
var PlayerList = []

func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	
	var Deck = DeckScene.instantiate()
	Deck.name = "Deck"
	Deck.Reset_Deck(DeckNumber)
	self.add_child(Deck)

func _on_player_connected():
	pass

func _on_player_disconnected():
	pass
	
func _on_server_disconnected():
	pass

# Creates dependent scenes.
func Ready_Game() -> void:
	$Deck.Reset_Deck(1)
	GameActive = true
	
	Game_Loop()
	
func Reset_Game() -> void:
	for player in NetworkManager.players:
		var CurrentPlayer = get_node(player)
		print("Player " + player + ": " + str(CurrentPlayer.get_node("Hand").Get_Value()))
		CurrentPlayer.reset()
	print("Dealer: " + str($Dealer.get_node("Hand").Get_Value()))
	$Dealer.reset()
	$Deck.reset()
	
	$MainMenu.View_In_Lobby()
	
func CheckPlayerStand(Players: Array) -> bool:
	var allstand = true

	for player in NetworkManager.players:
		if (get_node(player).Get_Stand() == false):
			allstand = false
	
	return allstand
	
func Game_Loop() -> void:
	while(GameActive):
		for player in NetworkManager.players:
			if (get_node(player).Get_Stand() == false):
				await Player_Action.rpc(player)
		Dealer_Turn()
		
		if ($Dealer.Get_Stand()) and (CheckPlayerStand(PlayerList) == true):
			GameActive = false
			Reset_Game()
	

@rpc("any_peer", "call_local", "reliable", 0)
func Player_Action(player: String) -> String:
	if (int(player) == multiplayer.get_unique_id()):
		var CurrentPlayer = get_node(player)
		CurrentPlayer.Set_Turn_Visible(true)
		
		print("Time to select an action, " + CurrentPlayer.name)
		
		var action = await CurrentPlayer.player_action
		
		CurrentPlayer.Set_Turn_Visible(false)
		
		return action
		
		if (action == "hit"):
			var drawncard: Array = $Deck.Give_Random_Card()
			
			# Case to select an Ace's value
			if (drawncard[2] == -1) and (CurrentPlayer.get_node("Hand").Get_Value() <= 10):
				print("Select the Ace's value, " + CurrentPlayer.name)
				
				CurrentPlayer.Set_Ace_Visible(true)
				
				var selected_value = await CurrentPlayer.player_action
				
				CurrentPlayer.Set_Ace_Visible(false)
				
				if(selected_value == "1"):
					drawncard[2] = 1
					
				elif (selected_value == "11"):
					drawncard[2] = 11
					
			elif (drawncard[2] == -1) and (CurrentPlayer.get_node("Hand").Get_Value() > 10):
				drawncard[2] = 1
			print(drawncard[0], drawncard[1], drawncard[2])
			CurrentPlayer.get_node("Hand").Get_Card(drawncard[0], drawncard[1], drawncard[2])
			print(CurrentPlayer.get_node("Hand").Get_Value())
			
		elif (action == "stand"):
			CurrentPlayer.Set_Stand(true)
		
		if (CurrentPlayer.get_node("Hand").Get_Value() == 21):
			CurrentPlayer.Set_Stand(true)
			
		elif(CurrentPlayer.get_node("Hand").Get_Value() > 21):
			CurrentPlayer.Set_Broke(true)
			CurrentPlayer.Set_Stand(true)
			
		
	
func Dealer_Turn() -> void:
	print("Time to select an action, Dealer")

	if ($Dealer.get_node("Hand").Get_Value() <= 16):
		var drawncard: Array = $Deck.Give_Random_Card()
		
		# Case to select an Ace's value
		if (drawncard[2] == -1) and ($Dealer.get_node("Hand").Get_Value() <= 10):
			drawncard[2] = 11
				
		elif (drawncard[2] == -1) and ($Dealer.get_node("Hand").Get_Value() > 10):
			drawncard[2] = 1
		
		$Dealer.get_node("Hand").Get_Card(drawncard[0], drawncard[1], drawncard[2])
		print($Dealer.get_node("Hand").Get_Value())
		
	else:
		$Dealer.Set_Stand(true)
	
	if ($Dealer.get_node("Hand").Get_Value() == 21):
		$Dealer.Set_Stand(true)
		
	elif($Dealer.get_node("Hand").Get_Value() > 21):
		$Dealer.Set_Broke(true)
		$Dealer.Set_Stand(true)
		
@rpc("any_peer", "call_local", "reliable", 0)
func UpdatePlayers(playerID, ):
	var CurrentPlayer = get_node(str(playerID))
	
	
func PlayerWin(playerid: int) -> void:
	pass
	
func DealerWin() -> void:
	pass
	
func Tie() -> void:
	pass
