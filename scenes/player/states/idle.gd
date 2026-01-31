class_name IdleState extends State


func enter(_msg := {}) -> void:
	owner.play_animation(self.name)


func physics_update(_delta: float) -> void:
	if owner.velocity != Vector2.ZERO:
		state_machine.transition_to("Move")
