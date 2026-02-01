class_name CastState extends State

var pending_spell_scene: PackedScene = null


func enter(msg := {}) -> void:
	handle_passed_spell(msg["spell_scene"])
	owner.velocity = Vector2.ZERO
	owner.set_can_move(false)


func handle_passed_spell(spell_scene):
	var inst = spell_scene.instantiate()
	if not inst is Spell:
		return
	
	var cast_delay = inst.CAST_DELAY
	if cast_delay > 0.0:
		var anim_length = owner.animation_player.get_animation(self.name).length
		var speed_scale = anim_length / inst.CAST_DELAY
		owner.animation_player.speed_scale = speed_scale
	owner.play_animation(self.name)
	owner.set_can_cast(false)
	
	inst.free()
	pending_spell_scene = spell_scene
	owner.update_facing_diection_cast()


func exit() -> void:
	owner.animation_player.speed_scale = 1.0


func _on_pre_cast_timer_ended() -> void:
	if pending_spell_scene:
		owner.cast_spell(pending_spell_scene)
		pending_spell_scene = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == self.name:
		_on_pre_cast_timer_ended()
		owner.set_can_move(true)
		owner.set_can_cast(true)
		state_machine.transition_to("Idle")
