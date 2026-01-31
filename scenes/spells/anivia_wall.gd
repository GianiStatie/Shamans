class_name AniviaWall
extends Spell

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	print('Help')
	queue_free()
