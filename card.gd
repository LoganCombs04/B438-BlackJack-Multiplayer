extends Sprite2D

class_name card

var suite: int = 1
var face: int = 1
var CardTexture = preload("res://Sprite-0001.png")
	
func _ready() -> void:
	if (get_tree().get_root().has_node("Main")):
		CardTexture = get_tree().get_root().get_node("Main").SpriteSheet
	
	self.texture = CardTexture
	$SuiteSprite.texture = CardTexture
	$FaceSprite.texture = CardTexture
	
	self.frame = 1
	$SuiteSprite.frame = (11 + suite)
	$FaceSprite.frame = (face)
	
	self.visible = true

func Get_Suite() -> int:
	return suite

func Get_Value() -> int:
	return face
