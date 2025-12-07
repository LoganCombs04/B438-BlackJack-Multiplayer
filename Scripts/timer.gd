extends Timer

signal finished

func _on_timeout() -> void:
	emit_signal("finished")
