extends Node

const CardScene: PackedScene = preload("res://Scenes/Card.tscn")
var CardsLeft: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		for j in 13:
			var newcard = CardScene.instantiate()
			newcard.suite = i
			newcard.face = j
			self.add_child(newcard)
			CardsLeft += 1

func Get_Count() -> int:
	return CardsLeft
