# Ad Maiorem Dei Gloriam!
extends Node

signal request_open_ui()
signal request_toggle_ui()
signal request_close_ui()

signal request_print_line(line: String)
signal request_clear_screen()
signal command_sent(command: PackedStringArray)

var is_terminal_ui_open: bool = false

# General logic commands
# The terminal manager sees if it can handle the request. If not, it propagates.
signal _command_sent_to_manager(command: PackedStringArray)
func _ready() -> void:
	_command_sent_to_manager.connect(_on_command_sent)
	
func _on_command_sent(command: PackedStringArray) -> void:
	match command[0]:
		"ls":
			var nodes := get_tree().get_nodes_in_group("AbleToDisable")
			for node_index in range(0, nodes.size()):
				var node: Node = nodes[node_index]
				if (node.has_method("toggle_disable")):
					request_print_line.emit("NOD_DIS%d" % node_index)
			return
		"toggle":
			if command.size() < 2:
				request_print_line.emit("[color=red]Error:[/color] No argument was provided.")
				return
			elif !command[1].is_valid_int():
				request_print_line.emit("[color=red]Error:[/color] Invalid Argument. Should be an int.")
				return
			
			var target: int = command[1].to_int()
			if target < 0:
				request_print_line.emit("[color=red]Error:[/color] Target should not be negative.")
				return
			var nodes: Array[Node] = get_tree().get_nodes_in_group("AbleToDisable")
			if target >= nodes.size():
				request_print_line.emit("[color=red]Error:[/color] The provided argument does not match any possible togabble node.")
				return
			
			if nodes[target].has_method("toggle_disable"):
				nodes[target].toggle_disable()
			return
	command_sent.emit(command)
