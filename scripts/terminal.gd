# Ad Maiorem Dei Gloriam!
class_name Terminal
extends Panel

@onready var input: LineEdit = $Margin/Control/VBoxContainer/InputLine
@onready var label: RichTextLabel = $Margin/Control/VBoxContainer/TextBuffer

var _built_in_commands: Dictionary[String, Callable] = {
	"clear": _clear
}

func _ready() -> void:
	TerminalManager.request_open_ui.connect(_on_terminal_open_ui_requested)
	TerminalManager.request_toggle_ui.connect(_on_terminal_toggle_ui_requested)
	TerminalManager.request_close_ui.connect(_on_terminal_close_ui_requested)
	TerminalManager.request_clear_screen.connect(clear)
	TerminalManager.request_print_line.connect(print_line)

func print_line(line: String) -> void:
	label.append_text(line + '\n')
	
func clear() -> void:
	label.clear()

func _on_input_line_text_submitted(new_text: String) -> void:
	print_line(new_text)
	var basic_parsed_command: PackedStringArray = _parse_input(new_text)
	if (_built_in_commands.has(basic_parsed_command[0])):
		_built_in_commands[basic_parsed_command[0]].call(basic_parsed_command)
	else:
		TerminalManager.command_sent.emit(basic_parsed_command)
	
	input.clear()
	_focus()

func _focus() -> void:
	input.release_focus()
	input.call_deferred("grab_focus")

func _on_terminal_open_ui_requested() -> void:
	visible = true
	_focus()

func _on_terminal_toggle_ui_requested() -> void:
	visible = !visible
	if visible:
		_focus()

func _on_terminal_close_ui_requested() -> void:
	visible = false

func _parse_input(command: String) -> PackedStringArray:
	return command.strip_edges().split(" ");
	
func _clear(_args: PackedStringArray) -> void:
	clear()
