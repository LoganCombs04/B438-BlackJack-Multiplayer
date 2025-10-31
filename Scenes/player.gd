extends Node

signal player_action(action: String)

func Set_Visible(state: bool) -> void:
	$Hit.visible = state
	$Stand.visible = state

func _on_hit_pressed() -> void:
	emit_signal("player_action", "hit")

func _on_stand_pressed() -> void:
	emit_signal("player_action", "stand")
