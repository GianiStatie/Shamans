class_name TauntState extends State


func enter(_msg := {}) -> void:
	owner.set_can_move(false)
	owner.play_animation(self.name)
	owner.play_tauntSFX()


func exit() -> void:
	owner.set_can_move(true)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state_machine.transition_to("Idle")
