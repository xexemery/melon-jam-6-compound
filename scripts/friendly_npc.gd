class_name FriendlyNPC
extends NPC


@onready var game_manager: Node = %GameManager
@onready var text_box: CanvasLayer = %TextBox
@onready var player: CharacterBody2D = %Player

enum Type {
	CRAB,
	DOG,
	OCTOPUS,
	RAT,
	SLIME,
	SNAKE,
	TORTOISE
}

var type: Type
var attack: int = 0
var defend: int = 0
var sneak: int = 0
var friend: int = 0


func _ready() -> void:
	text_box.option_selected.connect(_on_option_selected)


func get_type() -> String:
	match type:
		Type.CRAB:
			return "Crab"
		Type.DOG:
			return "Dog"
		Type.OCTOPUS:
			return "Octopus"
		Type.RAT:
			return "Rat"
		Type.SLIME:
			return "Slime"
		Type.SNAKE:
			return "Snake"
		Type.TORTOISE:
			return "Tortoise"
		_:
			return "FriendlyNPC"


func interact() -> void:
	text_box.queue_text(_display_stats())
	text_box.queue_text("Absorb this creature?")
	text_box.queue_options("Yes", "No")


func _display_stats() -> String:
	var stats: String = get_type() + "\n"

	if attack:
		stats += "Attack: " + _display_value(attack) + " "
	if defend:
		stats += "Defend: " + _display_value(defend) + " "
	if sneak:
		stats += "Sneak: " + _display_value(sneak) + " "
	if friend:
		stats += "Friend: " + _display_value(friend) + " "

	return stats


func _display_value(stat: int) -> String:
	var stat_string: String = ""
	var symbol: String = "+" if stat > 0 else "-"

	for n in abs(stat):
		stat_string += symbol

	return stat_string


func _on_option_selected(selection: int) -> void:
	if player.current_target != self:
		return

	if selection == 0:
		game_manager.add_to_party(self)
		get_parent().remove_child(self)
