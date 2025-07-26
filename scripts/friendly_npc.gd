class_name FriendlyNPC
extends NPC


@onready var text_box: CanvasLayer = %TextBox


func interact() -> void:
	text_box.queue_text("Add to party?")
