# Ad Maiorem Dei Gloriam!
extends Node

signal request_open_ui()
signal request_toggle_ui()
signal request_close_ui()

signal request_print_line(line: String)
signal request_clear_screen()
signal command_sent(command: PackedStringArray)
