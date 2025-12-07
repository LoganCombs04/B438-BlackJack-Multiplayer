extends Node

signal player_action(action: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Set_Turn_Visible(false)
	Set_Ace_Visible(false)
	$Hit.pressed.connect(_on_hit_pressed)
	$Stand.pressed.connect(_on_stand_pressed)
	$Ace1.pressed.connect(_on_ace_1_pressed)
	$Ace11.pressed.connect(_on_ace_11_pressed)

func Reset() -> void:
	Set_Turn_Visible(false)
	Set_Ace_Visible(false)

func Set_Turn_Visible(state: bool) -> void:
	$Hit.visible = state
	$Stand.visible = state
	
func Set_Ace_Visible(state: bool) -> void:
	$Ace1.visible = state
	$Ace11.visible = state

func _on_hit_pressed() -> void:
	emit_signal("player_action", "hit")
	print("Hit!")

func _on_stand_pressed() -> void:
	emit_signal("player_action", "stand")
	print("Stand!")

func _on_ace_1_pressed() -> void:
	emit_signal("player_action", "1")
	print("1!")

func _on_ace_11_pressed() -> void:
	emit_signal("player_action", "11")
	print("11!")
