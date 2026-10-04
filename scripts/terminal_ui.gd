# Ad Maiorem Dei Gloriam!
class_name TerminalUI
extends CanvasLayer

@onready var input: LineEdit = %InputLine
@onready var label: RichTextLabel = $Terminal/Margin/Control/VBoxContainer/TextBuffer

var _built_in_commands: Dictionary[String, Callable] = {
	"clear": _clear
}

func _ready() -> void:
	TerminalManager.is_terminal_ui_open = visible
	TerminalManager.request_open_ui.connect(_on_terminal_open_ui_requested)
	TerminalManager.request_toggle_ui.connect(_on_terminal_toggle_ui_requested)
	TerminalManager.request_close_ui.connect(_on_terminal_close_ui_requested)
	TerminalManager.request_clear_screen.connect(clear)
	TerminalManager.request_print_line.connect(print_line)

func print_line(line: String) -> void:
	label.append_text(line + '\n')
	
func clear() -> void:
	label.text = ""
	label.clear()
	
func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		TerminalManager.request_close_ui.emit()

func _on_input_line_text_submitted(new_text: String) -> void:
	input.clear()
	_focus()
	
	var sanitized_raw_command: String = new_text.strip_edges()
	print_line(%Home.text + sanitized_raw_command)
	
	var basic_parsed_command: PackedStringArray = _parse_input(sanitized_raw_command)
	if sanitized_raw_command.is_empty(): return
	if (_built_in_commands.has(basic_parsed_command[0])):
		_built_in_commands[basic_parsed_command[0]].call(basic_parsed_command)
	else:
		TerminalManager._command_sent_to_manager.emit(basic_parsed_command)
	

func _focus() -> void:
	input.release_focus()
	input.call_deferred("grab_focus")

func _on_terminal_open_ui_requested() -> void:
	visible = true
	TerminalManager.is_terminal_ui_open = visible
	_focus()

func _on_terminal_toggle_ui_requested() -> void:
	visible = !visible
	TerminalManager.is_terminal_ui_open = visible
	if visible:
		_focus()

func _on_terminal_close_ui_requested() -> void:
	visible = false
	TerminalManager.is_terminal_ui_open = visible

func _parse_input(sanitized_raw_command: String) -> PackedStringArray:
	return sanitized_raw_command.split(" ");
	
func _clear(_args: PackedStringArray) -> void:
	clear()
