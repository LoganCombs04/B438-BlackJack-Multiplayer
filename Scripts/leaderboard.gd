extends Node

var BoardScene: PackedScene = preload("res://Scenes/board_object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Set_Visible(false)
	
func Set_Visible(state: bool) -> void:
	for child in get_children():
		child.visible = state

func Set_Leaderboard(dealerScore: int, playerIDs: Array, playerScores: Array) -> void:
	var i = 0
	var startingY = 35
	
	$Background.show()
	
	var newboard = BoardScene.instantiate()
	newboard.get_node("Label").text = "Dealer: " + str(dealerScore)
	newboard.get_node("Label").size = Vector2(120, 35)
	newboard.get_node("Label").position = Vector2(116, startingY)
	self.add_child(newboard)
	
	startingY += 30
	
	for player in playerIDs:
		newboard = BoardScene.instantiate()
		newboard.get_node("Label").text = str(playerIDs[i]) + ": " + str(playerScores[i])
		newboard.get_node("Label").size = Vector2(120, 35)
		newboard.get_node("Label").position = Vector2(116, startingY)
		self.add_child(newboard)
		
		i+=1
		startingY += 30
	
func Reset() -> void:
	for child in get_children():
		if child.name != "Background":
			child.queue_free()
	$Background.hide()
