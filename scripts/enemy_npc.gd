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
	pass


func _handle_defend() -> void:
	pass


func _handle_sneak() -> void:
	pass


func _handle_befriend() -> void:
	pass
