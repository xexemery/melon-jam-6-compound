extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer


signal on_transition_finished


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	color_rect.hide()


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif animation_name == "fade_to_normal":
		color_rect.hide()


func transition() -> void:
	color_rect.show()
	animation_player.play("fade_to_black")
