class_name MoveState extends State


func enter(msg := {}) -> void:
	owner.cast_spell(msg["spell_scene"])
	owner.set_can_move(false)
	owner.play_animation(self.name)


func exit() -> void:
	owner.set_can_move(true)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == self.name:
		state_machine.transition_to("Idle")
