class_name FriendlyNPC
extends NPC


@onready var game_manager: Node = %GameManager
@onready var text_box: CanvasLayer = %TextBox


func _ready() -> void:
	text_box.option_selected.connect(_on_option_selected)


func interact() -> void:
	text_box.queue_text("Add to party?")
	text_box.queue_options("Yes", "No")


func _on_option_selected(selection: int) -> void:
	if selection == 0:
		game_manager.add_to_party(self)
		queue_free()
