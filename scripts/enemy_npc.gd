class_name EnemyNPC
extends NPC


@onready var game_manager: Node = %GameManager
@onready var text_box: CanvasLayer = %TextBox
@onready var player: CharacterBody2D = %Player

enum CombatStage {
	READY,
	DECISION,
	FIGHT,
	PEACE
}

var combat_stage: CombatStage = CombatStage.READY
var attack: int
var defend: int
var sneak_threshold: int
var friend_threshold: int


func _ready() -> void:
	text_box.option_selected.connect(_on_option_selected)


func interact() -> void:
	text_box.queue_text("Engage enemy?")
	text_box.queue_options("Yes", "No")


func _on_option_selected(selection: int) -> void:
	if player.current_target != self:
		return

	match combat_stage:
		CombatStage.READY:
			if selection == 0:
				_change_combat_stage(CombatStage.DECISION)
				text_box.queue_options("Combat", "Other")
		CombatStage.DECISION:
			if selection == 0:
				_change_combat_stage(CombatStage.FIGHT)
				text_box.queue_options("Attack", "Defend")
			else:
				_change_combat_stage(CombatStage.PEACE)
				text_box.queue_options("Sneak past", "Befriend")
		CombatStage.FIGHT:
			_change_combat_stage(CombatStage.READY)
			if selection == 0:
				_handle_attack()
			else:
				_handle_defend()
		CombatStage.PEACE:
			_change_combat_stage(CombatStage.READY)
			if selection == 0:
				_handle_sneak()
			else:
				_handle_befriend()


func _change_combat_stage(next_stage) -> void:
	combat_stage = next_stage
	match combat_stage:
		CombatStage.READY:
			print("Combat stage to CombatStage.READY")
		CombatStage.DECISION:
			print("Combat stage to CombatStage.DECISION")
		CombatStage.FIGHT:
			print("Combat stage to CombatStage.FIGHT")
		CombatStage.PEACE:
			print("Combat stage to CombatStage.PEACE")


func _handle_attack() -> void:
	if defend < 0:
		text_box.queue_text("You missed.")
		return

	if game_manager.party_attack > defend:
		text_box.queue_text("You defeated the enemy.")
		queue_free()
	else:
		text_box.queue_text("You aren't strong enough.")


func _handle_defend() -> void:
	if attack < 0:
		text_box.queue_text("They won't attack you.")
		return

	if game_manager.party_defend > attack:
		text_box.queue_text("You defend against the enemy's attack.")
		text_box.queue_text("They let you pass.")
		player.move_past(global_position)
	else:
		text_box.queue_text("You aren't strong enough.")
		if len(game_manager.party) == 0:
			game_manager.game_over()
		else:
			var index_to_remove: int = randi_range(0, len(game_manager.party))
			game_manager.remove_from_party(index_to_remove)


func _handle_sneak() -> void:
	if sneak_threshold < 0:
		text_box.queue_text("You can't sneak past them.")
		return

	if game_manager.party_sneak > sneak_threshold:
		text_box.queue_text("You sneak past.")
		player.move_past(global_position)
	else:
		text_box.queue_text("You couldn't sneak past.")


func _handle_befriend() -> void:
	if friend_threshold < 0:
		text_box.queue_text("You can't befriend this enemy.")
		return

	if game_manager.party_friend > friend_threshold:
		text_box.queue_text("You become friends!")
		text_box.queue_text("They let you pass.")
		# wait for text to finish first
		player.move_past(global_position)
	else:
		text_box.queue_text("They don't want to be friends.")
