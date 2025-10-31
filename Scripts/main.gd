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
	NewPlayer.Set_Visible(false)
	NewPlayer.name = "Little John"
	PlayerList.append(NewPlayer.name)
	self.add_child(NewPlayer)
	
	GameActive = true
	
	Game_Loop()
	
	
func Game_Loop() -> void:
	while(GameActive):
		for player in PlayerList:
			await Player_Turn(player)
		Dealer_Turn()
	
	
func Player_Turn(player: String) -> void:
	var CurrentPlayer = get_node("./" + player)
	CurrentPlayer.Set_Visible(true)
	
	print("Time to select an action, " + CurrentPlayer.name)
	
	var action = await CurrentPlayer.player_action
	if (action == "hit"):
		var drawncard = $Deck.Give_Random_Card()
		
		#make visible "ace choice" buttons if card is an ace and total would not be over 21
		#hide "ace choice" buttons
		if (drawncard.Get_Value() == -1):
			pass
		CurrentPlayer.find_child("Hand").Get_Card(drawncard)
		print(CurrentPlayer.find_child("Hand").Get_Value())
		pass
	elif (action == "stand"):
		#do not add total, and set a flag to skip this player's turn until the dealer beats or busts.
		pass
	
	if (CurrentPlayer.find_child("Hand").Get_Value() == 21):
		#Play win sequence
		pass
	elif(CurrentPlayer.find_child("Hand").Get_Value() > 21):
		#if player total is over twentyone, play the lose sequence
		pass
	elif(CurrentPlayer.find_child("Hand").Get_Value() < 21):
		#if player total is under twentyone, finish turn and pass to dealer.
		pass
	CurrentPlayer.Set_Visible(false)
	
func Dealer_Turn() -> void:
	pass
