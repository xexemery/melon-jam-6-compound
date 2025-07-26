class_name FriendlyNPC
extends NPC


@onready var game_manager: Node = %GameManager
@onready var text_box: CanvasLayer = %TextBox

enum Type {
	CRAB,
	DOG,
	OCTOPUS,
	RAT,
	SLIME,
	SNAKE,
	TORTOISE
}

var type: int
var attack: int = 0
var defend: int = 0
var sneak: int = 0
var friend: int = 0


func _ready() -> void:
	text_box.option_selected.connect(_on_option_selected)


func interact() -> void:
	text_box.queue_text(_display_stats())
	text_box.queue_text("Add to party?")
	text_box.queue_options("Yes", "No")


func _display_stats() -> String:
	var stats: String = ""

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
	if selection == 0:
		game_manager.add_to_party(self)
		queue_free()
