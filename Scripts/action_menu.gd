extends Node

var dealerscore: int

signal player_choice(action: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Set_Visible(false)
	Set_Hit_Disabled(true)
	Set_Ace_Disabled(true)
	$Hit.pressed.connect(_on_hit_pressed)
	$Stand.pressed.connect(_on_stand_pressed)
	$Ace1.pressed.connect(_on_ace_1_pressed)
	$Ace11.pressed.connect(_on_ace_11_pressed)

func Reset() -> void:
	Set_Hand_Value(0)
	Set_Dealer_Value(0)
	dealerscore = 0
	Set_Visible(false)
	Set_Hit_Disabled(true)
	Set_Ace_Disabled(true)

func Set_Visible(state: bool) -> void:
	$Hit.visible = state
	$Stand.visible = state
	$Ace1.visible = state
	$Ace11.visible = state
	$HandValue.visible = state
	$Background.visible = state
	$Name.visible = state
	$DealerName.visible = state
	$DealerValue.visible = state

func Set_Hit_Disabled(state: bool):
	$Hit.disabled = state
	$Stand.disabled = state

func Set_Ace_Disabled(state: bool):
	$Ace1.disabled = state
	$Ace11.disabled = state

func Set_Hand_Value(num: int):
	$HandValue.text = str(num)
	$HandValue.queue_redraw()

func Set_Player_Name(newname: String):
	$Name.text = newname
	
func Set_Dealer_Value(num: int):
	dealerscore = num
	$DealerValue.text = str(num)
	$DealerValue.queue_redraw()

func _on_hit_pressed() -> void:
	emit_signal("player_choice", "hit")
	print("Hit!")

func _on_stand_pressed() -> void:
	emit_signal("player_choice", "stand")
	print("Stand!")

func _on_ace_1_pressed() -> void:
	emit_signal("player_choice", "1")
	print("1!")

func _on_ace_11_pressed() -> void:
	emit_signal("player_choice", "11")
	print("11!")
