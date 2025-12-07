extends Node

signal turn
signal aceselected

const DeckScene: PackedScene = preload("res://Scenes/deck.tscn")
const DealerScene: PackedScene = preload("res://Scenes/dealer.tscn")
const PlayerScene: PackedScene = preload("res://Scenes/player.tscn")
const SpriteSheet: Texture2D = preload("res://Resources/Textures.png")

var DeckNumber: int = 1
var CurrentPlayer: Node
var GameActive: bool
var action: String
var aceAction: int

func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	
	$MainMenu/StartGame.pressed.connect(Ready_Game.rpc)
	$MainMenu/JoinLobby.pressed.connect(Join_Game)
	$MainMenu/CreateLobby.pressed.connect(NetworkManager.create_game)
	
func Join_Game():
	NetworkManager.join_game($MainMenu.get_node("IP").text)

func _on_player_connected(new_player_id, new_player_info):
	print(str(new_player_id) + " has joined the lobby!")
	$MainMenu/Status.text = ""

func _on_player_disconnected(playerID: int):
	print("ouch")
	Reset_Game.rpc()
	
func _on_server_disconnected():
	Reset_Game.rpc()

@rpc("any_peer", "call_local", "reliable", 0)
func Ready_Game():
	for player in NetworkManager.players:
			var pobject = PlayerScene.instantiate()
			pobject.name = str(player)
			self.add_child(pobject)
			print("Player of ID " + str(player) + " has had their hand created!")
		
	$MainMenu.Set_All_Hidden()
	
	if (multiplayer.get_unique_id() == 1):
		var Deck = DeckScene.instantiate()
		Deck.name = "Deck"
		Deck.Reset_Deck(DeckNumber)
		self.add_child(Deck)
		
		var Dealer = DealerScene.instantiate()
		Dealer.name = "Dealer"
		Dealer.reset()
		self.add_child(Dealer)
		
		GameActive = true
		Game_Loop()

@rpc("any_peer", "call_local", "reliable", 1)
func Reset_Game() -> void:
	print(str(multiplayer.get_unique_id()) + " has reset the game!")
	
	var GetPlayers = NetworkManager.players
	
	for player in GetPlayers:
		var CurrentPlayer = get_node(str(player))
		print("Player " + str(player) + ": " + str(get_node(str(player)).get_node("Hand").Get_Value()))
		CurrentPlayer.queue_free()
	
	if has_node("Dealer"):
		print("Dealer: " + str(get_node("Dealer").get_node("Hand").Get_Value()))
		$Dealer.queue_free()
	if has_node("Deck"):
		$Deck.queue_free()
	
	$ActionMenu.Reset()
	$MainMenu.View_In_Lobby()
	
func Game_Loop() -> void:
	while(GameActive):
		for player in NetworkManager.players:
			if (get_node(str(player)).Get_Stand() == false):
				print(str(get_node(str(player))) + " is now active!")
				Player_Action.rpc_id(player)
				
				await turn
				
				$Timer.start(3)
				await $Timer.timeout
				
				Player_Turn(action, player)
				
		Dealer_Turn()
		
		if ($Dealer.Get_Stand()) and (CheckPlayerStand() == true):
			GameActive = false
			Reset_Game()
	

@rpc("any_peer", "call_local", "reliable", 0)
func Player_Action() -> void:
	$ActionMenu.Set_Turn_Visible(true)
	print(str(multiplayer.get_unique_id()) + " has started their turn!")
	print("Time to select an action, " + str(multiplayer.get_unique_id()))
	
	action = await $ActionMenu.player_action
	
	$ActionMenu.Set_Turn_Visible(false)
	
	Set_Action.rpc_id(1, action)
	
	if (multiplayer.get_unique_id() != 1):
		action = ""
	
	Signal_All.rpc_id(1, "turn")
	
@rpc("any_peer", "call_local", "reliable", 0)
func Set_Action(choice: String) -> void:
	print("action has been set to " + str(choice) + str(multiplayer.get_unique_id()))
	action = choice
	
@rpc("any_peer", "call_local", "reliable", 0)
func Set_Ace_Action(choice: int) -> void:
	print("ace action has been set to " + str(choice) + str(multiplayer.get_unique_id()))
	aceAction = choice
	
@rpc("any_peer", "call_local", "reliable", 0)
func Signal_All(sig: String) -> void:
	print("signal has been emited: " + sig + " by " + str(multiplayer.get_unique_id()))
	emit_signal(sig)
	
@rpc("any_peer", "call_local", "reliable", 0)
func Select_Ace() -> void:
	print("Select the Ace's value, " + str(multiplayer.get_unique_id()))
	$ActionMenu.Set_Ace_Visible(true)
	
	var selected_value = await $ActionMenu.player_action
	
	$ActionMenu.Set_Ace_Visible(false)
	
	print(selected_value)
	
	Set_Ace_Action.rpc_id(1, selected_value)
	
	if (multiplayer.get_unique_id() != 1):
		action = ""
		
	Signal_All.rpc_id(1, "aceselected")

func Player_Turn(action: String, playerID: int) -> void:
	
	print("I am " + str(multiplayer.get_unique_id()) +  " calling player turn")
	
	if (action == "hit"):
		var drawncard: Array = $Deck.Give_Random_Card()
		
		# Case to select an Ace's value
		if (drawncard[2] == -1) and (get_node(str(playerID)).get_node("Hand").Get_Value() <= 10):
			Select_Ace.rpc_id(playerID)
			
			await aceselected
			
			$Timer.start(3)
			await $Timer.timeout
			
			drawncard[2] = int(action)
			
		elif (drawncard[2] == -1) and (get_node(str(playerID)).get_node("Hand").Get_Value() > 10):
			drawncard[2] = 1
			
		print("Player " + str(playerID) + " has drawn a card value of " + str(drawncard[2]))
		get_node(str(playerID)).get_node("Hand").Get_Card(drawncard[0], drawncard[1], drawncard[2])
		GlobalCardUpdate.rpc(playerID, drawncard)
		
	elif (action == "stand"):
		get_node(str(playerID)).Set_Stand(true)
	
	if (get_node(str(playerID)).get_node("Hand").Get_Value() == 21):
		get_node(str(playerID)).Set_Stand(true)
		
	elif(get_node(str(playerID)).get_node("Hand").Get_Value() > 21):
		get_node(str(playerID)).Set_Broke(true)
		get_node(str(playerID)).Set_Stand(true)
		
	print(str(playerID) + ": Hand value is " + str(get_node(str(playerID)).get_node("Hand").Get_Value()))
		
	
func Dealer_Turn() -> void:
	print("Time to select an action, Dealer")

	if ($Dealer.get_node("Hand").Get_Value() <= 16):
		var drawncard: Array = $Deck.Give_Random_Card()
		
		# Case to select an Ace's value
		if (drawncard[2] == -1) and ($Dealer.get_node("Hand").Get_Value() <= 10):
			drawncard[2] = 11
				
		elif (drawncard[2] == -1) and ($Dealer.get_node("Hand").Get_Value() > 10):
			drawncard[2] = 1
		
		print("Dealer card value: " + str(drawncard[2]))
		$Dealer.get_node("Hand").Get_Card(drawncard[0], drawncard[1], drawncard[2])
		
	else:
		$Dealer.Set_Stand(true)
	
	if ($Dealer.get_node("Hand").Get_Value() == 21):
		$Dealer.Set_Stand(true)
		
	elif ($Dealer.get_node("Hand").Get_Value() > 21):
		$Dealer.Set_Broke(true)
		$Dealer.Set_Stand(true)
		
	print("Dealer hand value:" + str($Dealer.get_node("Hand").Get_Value()))

@rpc("any_peer", "call_remote", "reliable", 0)
func GlobalCardUpdate(playerID: int, newcard: Array) -> void:
	if (multiplayer.get_unique_id() != playerID):
		get_node(str(playerID)).get_node("Hand").Get_Card(newcard[0], newcard[1], newcard[2])
		
	
func CheckPlayerStand() -> bool:
	var allstand = true

	for player in NetworkManager.players:
		if (get_node(str(player)).Get_Stand() == false):
			allstand = false
	
	return allstand
	
func PlayerWin(playerid: int) -> void:
	pass
	
func DealerWin() -> void:
	pass
	
func Tie() -> void:
	pass
