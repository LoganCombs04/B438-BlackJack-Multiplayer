extends Node

const DeckScene: PackedScene = preload("res://Scenes/deck.tscn")
const Player: PackedScene = preload("res://Scenes/player.tscn")
const SpriteSheet: Texture2D = preload("res://Resources/Textures.png")

var DeckNumber: int = 1
var GameActive: bool
var PlayerList = []

# Creates dependent scenes.
func Ready_Game() -> void:
	$Deck.Reset_Deck(1)
	
	var NewPlayer = Player.instantiate()
	NewPlayer.name = "Little John"
	PlayerList.append(NewPlayer.name)
	self.add_child(NewPlayer)
	
	GameActive = true
	
	Game_Loop()
	
	
func Game_Loop() -> void:
	while(GameActive):
		for player in PlayerList:
			if (get_node("./" + player).Get_Stand() == false):
				await Player_Turn(player)
		Dealer_Turn()
	
	
func Player_Turn(player: String) -> void:
	var CurrentPlayer = get_node(player)
	CurrentPlayer.Set_Turn_Visible(true)
	
	print("Time to select an action, " + CurrentPlayer.name)
	
	var action = await CurrentPlayer.player_action
	
	CurrentPlayer.Set_Turn_Visible(false)
	
	if (action == "hit"):
		var drawncard: card = $Deck.Give_Random_Card()
		
		# Case to select an Ace's value
		if (drawncard.Get_Value() == -1) and (CurrentPlayer.get_Node("Hand").Get_Value() <= 10):
			CurrentPlayer.Set_Ace_Visible(true)
			
			var selected_value = await CurrentPlayer.player_action
			
			CurrentPlayer.Set_Ace_Visible(false)
			
			if(selected_value == "1"):
				drawncard.Set_Value(1)
				
			elif (selected_value == "11"):
				drawncard.Set_Value(11)
				
		elif (drawncard.Get_Value() == -1) and (CurrentPlayer.get_Node("Hand").Get_Value() > 10):
			drawncard.Set_Value(1)
		
		CurrentPlayer.get_node("Hand").Get_Card(drawncard)
		print(CurrentPlayer.get_node("Hand").Get_Value())
		
	elif (action == "stand"):
		CurrentPlayer.Set_Stand(true)
	
	if (CurrentPlayer.get_node("Hand").Get_Value() == 21):
		#Play win sequence
		pass
	elif(CurrentPlayer.get_node("Hand").Get_Value() > 21):
		#if player total is over twentyone, play the lose sequence
		pass
	elif(CurrentPlayer.get_node("Hand").Get_Value() < 21):
		#if player total is under twentyone, finish turn and pass to dealer.
		pass
	
func Dealer_Turn() -> void:
	pass
