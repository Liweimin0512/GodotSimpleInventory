extends Node2D

@onready var inventory: MarginContainer = %inventory
@onready var line_edit: LineEdit = %LineEdit
@onready var btn_submit: Button = %btn_submit
@onready var player: Node2D = %player

func _ready() -> void:
	inventory.c_inventory = player.get_node("C_Inventory")

func process_command(command: String):
	var parts = command.split(" ")
	if parts.size() == 0:
		return

	var cmd = parts[0]
	var args = parts.slice(1, parts.size())

	if has_method(cmd):
		self.callv(cmd, args)
	else:
		push_warning("未找到指定的命令：", cmd)

func add_item(item_name: String, item_count: String) -> void:
	var _count = int(item_count)
	var item = create_item(item_name, _count)
	if item == null: return
	var c_inventory: C_Inventory = player.get_node("C_Inventory")
	c_inventory.add_item(item)
	print_debug("add_item: ", item_name, " count: ", item_count)

func remove_item(slot_index: String) -> void:
	var _index = int(slot_index)
	var c_inventory: C_Inventory = player.get_node("C_Inventory")
	c_inventory.remove_item(_index)

func create_item(item_name, item_count) -> Item:
	var res_path : String = "res://src/items/" + item_name + ".tres"
	if not ResourceLoader.exists(res_path): return null
	var item : Item = load(res_path).duplicate()
	item.quantity = item_count
	return item

func _on_texture_button_pressed() -> void:
	inventory.open()

func _on_line_edit_text_submitted(new_text: String) -> void:
	process_command(new_text)

func _on_btn_submit_pressed() -> void:
	process_command(line_edit.text)
