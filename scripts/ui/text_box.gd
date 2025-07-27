extends CanvasLayer


@onready var text_box_container: MarginContainer = $TextBoxContainer
@onready var start_symbol: Label = $TextBoxContainer/MarginContainer/TextContainer/Start
@onready var end_symbol: Label = $TextBoxContainer/MarginContainer/TextContainer/End
@onready var label: Label = $TextBoxContainer/MarginContainer/TextContainer/Label

@onready var selector_1: Label = $TextBoxContainer/MarginContainer/MenuContainer/Selector1
@onready var selector_2: Label = $TextBoxContainer/MarginContainer/MenuContainer/Selector2
@onready var label_1: Label = $TextBoxContainer/MarginContainer/MenuContainer/Label1
@onready var label_2: Label = $TextBoxContainer/MarginContainer/MenuContainer/Label2

const CHAR_READ_RATE = 0.03
var text_tween: Tween
var duration: float

enum State {
	READY,
	READING,
	FINISHED,
	OPTIONS
}

var current_state: State = State.READY
var text_queue: Array[String] = []
var options_queue: Array[String] = []
var current_selection: int = 0


signal text_finished()
signal option_selected(selection: int)


func _ready() -> void:
	_hide_text_box()
	_hide_options_box()


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				get_tree().paused = true
				_display_text()
			elif not options_queue.is_empty():
				get_tree().paused = true
				_display_options()
		State.READING:
			if Input.is_action_just_pressed("interact"):
				label.visible_ratio = 1.0
				text_tween.kill()
				_on_text_finished()
		State.FINISHED:
			if Input.is_action_just_pressed("interact"):
				_change_state(State.READY)
				if text_queue.is_empty():
					_hide_text_box()
		State.OPTIONS:
			if Input.is_action_just_pressed("right") and current_selection < 1:
				current_selection += 1
				_set_current_selection(current_selection)
			elif Input.is_action_just_pressed("left") and current_selection > 0:
				current_selection -= 1
				_set_current_selection(current_selection)
			elif Input.is_action_just_pressed("interact"):
				_on_option_accept(current_selection)


func queue_text(next_text: String) -> void:
	text_queue.push_back(next_text)


func queue_options(option1, option2) -> void:
	options_queue.push_back(option1)
	options_queue.push_back(option2)


func kill_options() -> void:
	options_queue = []
	_change_state(State.READY)
	_hide_options_box()


func _hide_text_box() -> void:
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""

	if options_queue.is_empty():
		text_box_container.hide()
		get_tree().paused = false
		text_finished.emit()


func _hide_options_box() -> void:
	selector_1.text = ""
	selector_2.text = ""
	label_1.text = ""
	label_2.text = ""

	if text_queue.is_empty():
		text_box_container.hide()
		get_tree().paused = false


func _show_text_box() -> void:
	start_symbol.text = ">"
	text_box_container.show()


func _show_options_box() -> void:
	current_selection = 0
	_set_current_selection(current_selection)
	text_box_container.show()


func _change_state(next_state) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to State.READY")
		State.READING:
			print("Changing state to State.READING")
		State.FINISHED:
			print("Changing state to State.FINISHED")
		State.OPTIONS:
			print("Changing state to State.OPTIONS")


func _display_text() -> void:
	var next_text: String = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	_change_state(State.READING)
	_show_text_box()

	text_tween = create_tween()
	duration = len(next_text) * CHAR_READ_RATE
	text_tween.tween_property(label, "visible_ratio", 1.0, duration)
	text_tween.connect("finished", _on_text_finished)


func _on_text_finished() -> void:
	end_symbol.text = "..."
	_change_state(State.FINISHED)


func _display_options() -> void:
	label_1.text = options_queue.get(0)
	label_2.text = options_queue.get(1)
	_change_state(State.OPTIONS)
	_show_options_box()


func _set_current_selection(selection: int) -> void:
	selector_1.text = ""
	selector_2.text = ""

	if selection == 0:
		selector_1.text = ">"
	elif selection == 1:
		selector_2.text = ">"


func _on_option_accept(selection: int) -> void:
	options_queue = []
	_change_state(State.READY)
	option_selected.emit(selection)

	if options_queue.is_empty():
		_hide_options_box()
