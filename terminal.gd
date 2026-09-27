# Ad Maiorem Dei Gloriam!
class_name Terminal
extends Panel

@onready var input: LineEdit = $Margin/Control/VBoxContainer/InputLine
@onready var label: RichTextLabel = $Margin/Control/VBoxContainer/TextBuffer

func _ready() -> void:
	print_line("Hello, world!")

func print_line(line: String) -> void:
	label.append_text(line + '\n')


func _on_input_line_text_submitted(new_text: String) -> void:
	print_line(new_text)
	
