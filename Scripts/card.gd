extends Sprite2D

class_name card

var CardTexture = preload("res://Resources/Textures.png")

var suite: int = 0
var face: int = 0
var value: int = 0
	
func _ready() -> void:
	# Changes the spritesheet to the loaded/selected spritesheet when game is running. 
	# Will use default spritesheet if the Main load is not loaded.
	if (get_tree().get_root().has_node("Main")):
		CardTexture = get_tree().get_root().get_node("Main").SpriteSheet
	
	# Sets the texture for each card.
	self.texture = CardTexture
	$SuiteSprite.texture = CardTexture
	$FaceSprite.texture = CardTexture
	
	# Sets the face/value for each card.
	self.frame = 15
	$SuiteSprite.frame = (11 + suite)
	$FaceSprite.frame = (face)
	
func Get_Suite() -> int:
	return suite

func Get_Value() -> int:
	return value
	
func Get_Face() -> int:
	return face
	
func Set_Value(newvalue: int) -> void:
	self.value = newvalue
