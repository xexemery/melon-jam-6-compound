extends CanvasLayer


@onready var text_box_container: MarginContainer = $TextBoxContainer
@onready var start_symbol: Label = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol: Label = $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var label: Label = $TextBoxContainer/MarginContainer/HBoxContainer/Label

const CHAR_READ_RATE = 0.03
var text_tween: Tween
var duration: float

enum State {
	READY,
	READING,
	FINISHED
}

var current_state: State = State.READY
var text_queue: Array[String] = []


func _ready() -> void:
	print(current_state)
	_hide_text_box()
	_queue_text("Add to party? Add to party? Add to party?")
	_queue_text("Do you want to add to party?")
	_queue_text("How about now?")
	_queue_text("Add to party? Add to party? Add to party?")


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				_display_text()
		State.READING:
			if Input.is_action_just_pressed("interact"):
				label.visible_ratio = 1.0
				text_tween.kill()
				end_symbol.text = "..."
				_change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("interact"):
				_change_state(State.READY)
				_hide_text_box()


func _queue_text(next_text: String) -> void:
	text_queue.push_back(next_text)


func _hide_text_box() -> void:
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	text_box_container.hide()


func _show_text_box() -> void:
	start_symbol.text = ">"
	text_box_container.show()


func _display_text() -> void:
	var next_text: String = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	_change_state(State.READING)
	_show_text_box()

	text_tween = create_tween()
	duration = len(next_text) * CHAR_READ_RATE
	text_tween.tween_property(label, "visible_ratio", 1.0, duration)

	await text_tween.finished
	end_symbol.text = "..."
	_change_state(State.FINISHED)


func _change_state(next_state) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to State.READY")
		State.READING:
			print("Changing state to State.READING")
		State.FINISHED:
			print("Changing state to State.FINISHED")
